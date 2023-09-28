from sqlite3 import IntegrityError
from fastapi import APIRouter, status, Depends
from lib.authentication.authentication import oauth2_scheme, get_current_user
from models.majors_models import MajorIn, MajorOut, MajorUpdate
from lib.database.manager import DataBaseManager
from lib.checks.checks import major_exists
from lib.exceptions.majors import MajorNotFound, MajorAlreadyExists

majors = APIRouter(
    prefix="/majors",
    tags=["majors"]
)


@majors.post("/", response_model=MajorOut, status_code=status.HTTP_201_CREATED)
async def create_major(major: MajorIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    try:
        major_id = await DataBaseManager().create_major(major)
    except IntegrityError:
        raise MajorAlreadyExists()
    return {**major.dict(), "id": major_id}


@majors.get("/{major_id}", response_model=MajorOut, status_code=status.HTTP_200_OK)
async def get_major(major_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    major = await DataBaseManager().get_major(major_id)
    if not major:
        raise MajorNotFound()
    return major


@majors.get("/", response_model=list[MajorOut], status_code=status.HTTP_200_OK)
async def get_all_majors(token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    return await DataBaseManager().get_all_majors()


@majors.put("/{major_id}", response_model=MajorOut, status_code=status.HTTP_200_OK)
async def update_major(major_id: int, major: MajorUpdate, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await major_exists(major_id):
        raise MajorNotFound()
    try:
        await DataBaseManager().update_major(major_id, major)
    except IntegrityError:
        raise MajorAlreadyExists()
    return {**major.dict(), "id": major_id}


@majors.delete("/{major_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_major(major_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await major_exists(major_id):
        raise MajorNotFound()
    await DataBaseManager().delete_major(major_id)