from fastapi import APIRouter, Depends, status
from lib.authentication.authentication import Authentication, oauth2_scheme, get_current_user
from fastapi.security import OAuth2PasswordRequestForm
from lib.database.manager import DataBaseManager
from models.owners_models import OwnerOut
from lib.exceptions.owners import WrongEmailOrPassword


owners = APIRouter(
    prefix="/owners",
    tags=["owners"],
)


@owners.post("/login", status_code=status.HTTP_200_OK)
async def login_owner(form_data: OAuth2PasswordRequestForm = Depends()):
    owner = await DataBaseManager().get_owner(form_data.username)
    if not owner:
        raise WrongEmailOrPassword()
    if not Authentication.verify_password(form_data.password, owner.password):
        raise WrongEmailOrPassword()
    
    access_token = Authentication().create_access_token({"id": owner.id, "role": "owner"})
    refresh_token = Authentication().create_refresh_token({"id": owner.id, "role": "owner"})
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}

@owners.post("/refresh", status_code=status.HTTP_200_OK)
async def refresh_owner(token: str = Depends(oauth2_scheme)):
    access_token, refresh_token = Authentication().refresh_token(token)
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}

@owners.get("/me", response_model=OwnerOut, status_code=status.HTTP_200_OK)
async def get_me(token: str = Depends(oauth2_scheme)):
    owner = await get_current_user("owner", token=token)
    return owner