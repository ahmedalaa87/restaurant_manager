from fastapi import APIRouter, status
from lib.database.manager import DataBaseManger
from models.admins_models import AdminIn, AdminOut, AdminPasswordUpdate, AdminUpdate
from sqlite3 import IntegrityError
from lib.checks.checks import admin_exists
from lib.exceptions.admins import AdminNotFound, EmailAlreadyExists, WrongEmailOrPassword, WrongPassword

admins = APIRouter(
    prefix="/admins",
    tags=["admins"]
)


@admins.post("/", response_model=AdminOut, status_code=status.HTTP_201_CREATED)
async def create_admin(admin: AdminIn):
    try:
        id = await DataBaseManger().create_admin(admin)
    except IntegrityError:
        raise EmailAlreadyExists
    
    return {**admin.dict(), "id": id}


@admins.get("/{id}", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def get_admin(id: int):
    admin = await DataBaseManger().get_admin(id)
    if not admin:
        raise AdminNotFound()
    
    return admin


@admins.get("/", response_model=list[AdminOut], status_code=status.HTTP_200_OK)
async def get_all_admins():
    return await DataBaseManger().get_all_admins()


@admins.put("/{id}", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def update_admin(id: int, admin: AdminUpdate):
    if not await admin_exists(id):
        raise AdminNotFound()
    
    await DataBaseManger().update_admin(id, **admin.dict())
    return {**admin.dict(), "id": id}


@admins.patch("/reset_password", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def update_admin_password(admin: AdminPasswordUpdate):
    
    await DataBaseManger().update_admin_password(id, admin.new_password)


@admins.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_admin(id: int):
    if not await admin_exists(id):
        raise AdminNotFound()
    
    await DataBaseManger().delete_admin(id)