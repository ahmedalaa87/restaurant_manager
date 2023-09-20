from fastapi import APIRouter, Depends, status
from lib.database.manager import DataBaseManger
from models.owners_models import OwnerBase, OwnerOut
from lib.exceptions.owners import WrongEmailOrPassword


owners = APIRouter(
    prefix="/owners",
    tags=["owners"],
)


# @owners.post("/login", response_model=OwnerOut, status_code=status.HTTP_200_OK)
# async def login(owner: OwnerBase, db: DataBaseManger = Depends()):
#     db_owner = await db.get_owner_by_email(owner.email)
#     if db_owner is None or db_owner.password != owner.password:
#         raise WrongEmailOrPassword()
#     return db_owner


# @owners.get("/me", response_model=OwnerOut, status_code=status.HTTP_200_OK)
# async def get_me(owner: OwnerOut = Depends(), db: DataBaseManger = Depends()):
#     return await db.get_owner(owner.id)