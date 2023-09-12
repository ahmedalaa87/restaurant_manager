from sqlite3 import IntegrityError
from fastapi import APIRouter, status
from lib.checks.checks import meal_type_exists
from models.meal_types_models import MealTypeIn, MealTypeOut
from lib.exceptions.meal_types import MealTypeAlreadyExists, MealTypeNotFound
from lib.database.manager import DataBaseManger


meal_types = APIRouter(
    prefix= "/meal_types",
    tags= ["meal_types"]
)

@meal_types.get("/", response_model=list[MealTypeOut], status_code=status.HTTP_200_OK)
async def get_all_majors():
    return await DataBaseManger().get_all_meal_types()

@meal_types.get("/{meal_type_id}", response_model=MealTypeOut, status_code=status.HTTP_200_OK)
async def get_meal_type(meal_type_id: int):
    meal_type = await DataBaseManger().get_meal_type_by_id(meal_type_id)
    if not meal_type:
        raise MealTypeNotFound()
    return meal_type

@meal_types.post("/", response_model=MealTypeOut, status_code=status.HTTP_201_CREATED)
async def create_meal_type(meal_type: MealTypeIn):
    try:
        meal_type_id = await DataBaseManger().create_meal_type(meal_type)
    except IntegrityError:
        raise MealTypeAlreadyExists()
    return {**meal_type.dict(), "id": meal_type_id}

@meal_types.put("/{meal_type_id}", response_model=MealTypeOut, status_code=status.HTTP_200_OK)
async def update_meal_type(meal_type_id: int, meal_type: MealTypeIn):
    if not await meal_type_exists(meal_type_id):
        raise MealTypeNotFound()
    try:
        await DataBaseManger().update_meal_type(meal_type_id, meal_type)
    
    except IntegrityError:
        raise MealTypeAlreadyExists
    return {**meal_type.dict(), "id": meal_type_id}

@meal_types.delete("/{meal_type_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_meal_type(meal_type_id: int):
    if not await meal_type_exists(meal_type_id):
        raise MealTypeNotFound
    await DataBaseManger().delete_meal_type(meal_type_id)
