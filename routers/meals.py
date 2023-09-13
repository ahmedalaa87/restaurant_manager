from fastapi import APIRouter, status
from lib.checks.checks import meal_exists, student_exists, meal_type_exists, student_has_meal_type_today
from models.meals_models import MealIn, MealOut
from lib.exceptions.meals import MealNotFound, StudentAlreadyHasMeal
from lib.exceptions.students import StudentNotFound
from lib.exceptions.meal_types import MealTypeNotFound
from lib.database.manager import DataBaseManger
from datetime import date

meals = APIRouter(
    prefix="/meals",
    tags=["meals"]
)


@meals.post("/", response_model=MealOut, status_code=status.HTTP_201_CREATED)
async def create_meal(meal: MealIn):
    if not await meal_type_exists(meal.meal_type_id):
        raise MealTypeNotFound()
    if not await student_exists(meal.student_id):
        raise StudentNotFound()
    if await student_has_meal_type_today(meal.student_id, meal.meal_type_id):
        raise StudentAlreadyHasMeal()
    meal_id = await DataBaseManger().create_meal(meal)
    return {"id": meal_id, **meal.dict()}


@meals.get("/{meal_id}", response_model=MealOut)
async def get_meal(meal_id: int):
    meal = await DataBaseManger().get_meal(meal_id)
    if not meal:
        raise MealNotFound()
    return meal


@meals.get("/", response_model=list[MealOut])
async def get_all_meals():
    return await DataBaseManger().get_all_meals()


@meals.put("/{meal_id}", response_model=MealOut)
async def update_meal(meal_id: int, meal: MealIn):
    if not await meal_exists(meal_id):
        raise MealNotFound()
    await DataBaseManger().update_meal(meal_id, meal)
    return {"id": meal_id, **meal.dict()}


@meals.delete("/{meal_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_meal(meal_id: int):
    if not await meal_exists(meal_id):
        raise MealNotFound()
    await DataBaseManger().delete_meal(meal_id)


@meals.get("/student/{student_id}", response_model=list[MealOut])
async def get_student_meals(student_id: int):
    if not await student_exists(student_id):
        raise StudentNotFound()
    return await DataBaseManger().get_student_meals(student_id)


@meals.get("/date/student/{student_id}", response_model=list[MealOut])
async def get_student_meals_by_date(student_id: int, date: date = None):
    if not await student_exists(student_id):
        raise StudentNotFound()
    return await DataBaseManger().get_student_meals_by_date(student_id, date)


@meals.get("/date/student/{student_id}/{meal_type_id}", response_model=MealOut)
async def get_student_meal_by_date_and_meal_type(student_id: int, meal_type_id: int, date: date = None):
    if not await student_exists(student_id):
        raise StudentNotFound()
    if not await meal_type_exists(meal_type_id):
        raise MealTypeNotFound()
    meal = await DataBaseManger().get_student_meal_by_date_and_meal_type(student_id, meal_type_id, date)
    if not meal:
        raise MealNotFound()
    return meal

