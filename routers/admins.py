from fastapi import APIRouter, status, Depends
from lib.authentication.authentication import Authentication, oauth2_scheme, get_current_user
from fastapi.security import OAuth2PasswordRequestForm
from lib.database.manager import DataBaseManager
from models.admins_models import AdminIn, AdminOut, AdminPasswordUpdate, AdminUpdate
from sqlite3 import IntegrityError
from lib.checks.checks import admin_exists
from lib.exceptions.admins import AdminNotFound, EmailAlreadyExists, WrongEmailOrPassword, WrongPassword

admins = APIRouter(
    prefix="/admins",
    tags=["admins"]
)


@admins.post("/", response_model=AdminOut, status_code=status.HTTP_201_CREATED)
async def create_admin(admin: AdminIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("owner", token=token)
    try:
        id = await DataBaseManager().create_admin(admin)
    except IntegrityError:
        raise EmailAlreadyExists
    
    return {**admin.dict(), "id": id}


@admins.post("/login", status_code=status.HTTP_200_OK)
async def login_admin(form_data: OAuth2PasswordRequestForm = Depends()):
    admin = await DataBaseManager().get_admin(form_data.username)
    if not admin:
        raise WrongEmailOrPassword()
    if not Authentication.verify_password(form_data.password, admin.password):
        raise WrongEmailOrPassword()
    
    access_token = Authentication().create_access_token({"id": admin.id, "role": "admin"})
    refresh_token = Authentication().create_refresh_token({"id": admin.id, "role": "admin"})
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}


@admins.post("/refresh", status_code=status.HTTP_200_OK)
async def refresh_admin(token: str = Depends(oauth2_scheme)):
    access_token, refresh_token = Authentication().refresh_token(token)
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}


@admins.get("/me", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def get_me(token: str = Depends(oauth2_scheme)):
    admin = await get_current_user("admin", token=token)
    return admin


@admins.get("/{id}", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def get_admin(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", "owner", token=token)
    admin = await DataBaseManager().get_admin(id)
    if not admin:
        raise AdminNotFound()
    
    return admin


@admins.get("/", response_model=list[AdminOut], status_code=status.HTTP_200_OK)
async def get_all_admins(token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", "owner", token=token)
    return await DataBaseManager().get_all_admins()


@admins.put("/{id}", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def update_admin(id: int, admin: AdminUpdate, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("owner", token=token)
    if not await admin_exists(id):
        raise AdminNotFound()
    
    await DataBaseManager().update_admin(id, **admin.dict())
    return {**admin.dict(), "id": id}


@admins.patch("/reset_password", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def update_admin_password(admin: AdminPasswordUpdate, token: str = Depends(oauth2_scheme)):
    admin = await get_current_user("admin", token=token)
    if not Authentication.verify_password(admin.old_password, admin.new_password):
        raise WrongPassword()
    
    await DataBaseManager().update_admin_password(id, admin.new_password)


@admins.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_admin(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("owner", token=token)
    if not await admin_exists(id):
        raise AdminNotFound()
    
    await DataBaseManager().delete_admin(id)