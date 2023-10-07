from fastapi import APIRouter, status, Depends, Query
from lib.authentication.authentication import oauth2_scheme, get_current_user
from lib.checks.checks import (
    meal_exists,
    meal_type_created_today,
    meal_type_exists,
    student_has_meal_today,
    student_is_absent_today,
    student_is_stayer,
)
from lib.exceptions.meal_students import (
    StudentAlreadyHasMeal,
    StudentIsAbsent,
    StudentIsNotStayer,
)
from lib.exceptions.students import StudentNotFound
from models.meal_students_models import MealStudentIn
from models.meals_models import MealIn, MealOut, MealUpdate
from lib.exceptions.meals import MealNotFound
from lib.exceptions.meal_types import MealTypeNotFound
from lib.database.manager import DataBaseManager
from datetime import date, datetime
from fastapi_pagination import Page

from models.students_models import StudentOut

meals = APIRouter(prefix="/meals", tags=["meals"])

Page = Page.with_custom_options(size=Query(20, ge=1, le=100000))


@meals.post("/", response_model=MealOut, status_code=status.HTTP_201_CREATED)
async def create_meal(meal: MealIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await meal_type_exists(meal.meal_type_id):
        raise MealTypeNotFound()

    if await meal_type_created_today(meal.meal_type_id):
        raise 

    meal_id = await DataBaseManager().create_meal(meal)
    return {"id": meal_id, **meal.dict()}


@meals.get("/date", response_model=Page[MealOut])
async def get_meals_by_date(date: date = None, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    return await DataBaseManager().get_meals_by_date(date)


@meals.get("/", response_model=Page[MealOut])
async def get_all_meals(token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    return await DataBaseManager().get_all_meals()


@meals.get("/{meal_id}", response_model=MealOut)
async def get_meal(meal_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    meal = await DataBaseManager().get_meal(meal_id)
    if not meal:
        raise MealNotFound()
    students = await DataBaseManager().get_meal_students_info(meal_id)
    return {"id": meal_id, **meal, "students": students}


@meals.get("/meal_type/{meal_type_id}", response_model=Page[MealOut])
async def get_meals_by_meal_type(
    meal_type_id: int, token: str = Depends(oauth2_scheme)
):
    _ = await get_current_user("admin", token=token)
    if not await meal_type_exists(meal_type_id):
        raise MealTypeNotFound()
    return await DataBaseManager().get_meals_by_meal_type(meal_type_id)


@meals.get("/date/{meal_type_id}", response_model=MealOut)
async def get_meal_by_date_and_meal_type(
    meal_type_id: int, date: date = None, token: str = Depends(oauth2_scheme)
):
    _ = await get_current_user("admin", token=token)
    if not await meal_type_exists(meal_type_id):
        raise MealTypeNotFound()
    return await DataBaseManager().get_meal_by_date_and_meal_type(meal_type_id, date)


@meals.put("/add_student", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def create_meal_student(
    meal_student: MealStudentIn, token: str = Depends(oauth2_scheme)
):
    _ = await get_current_user("admin", token=token)
    meal = await DataBaseManager().get_meal(meal_student.meal_id)
    if not meal:
        raise MealNotFound()
    student = await DataBaseManager().get_student(meal_student.student_id)
    if not student:
        raise StudentNotFound()
    if await student_has_meal_today(meal_student.student_id, meal_student.meal_id):
        raise StudentAlreadyHasMeal()
    if (
        await student_is_absent_today(meal_student.student_id)
        and meal.meal_type_id == 2
        and datetime.now().weekday() != 3
    ):
        raise StudentIsAbsent()
    if datetime.now().weekday() == 3 and meal.meal_type_id in [2, 3] and not await student_is_stayer(meal_student.student_id):
        raise StudentIsNotStayer()
    if datetime.now().weekday() == 4 and not await student_is_stayer(meal_student.student_id):
        raise StudentIsNotStayer()
    if datetime.now().weekday() == 5 and meal.meal_type_id in [1, 2] and not await student_is_stayer(meal_student.student_id):
        raise StudentIsNotStayer()
    
    await DataBaseManager().create_meal_student(meal_student)
    return student


@meals.put("/{meal_id}", status_code=status.HTTP_204_NO_CONTENT)
async def update_meal(
    meal_id: int, meal: MealUpdate, token: str = Depends(oauth2_scheme)
):
    _ = await get_current_user("admin", token=token)
    if not await meal_exists(meal_id):
        raise MealNotFound()
    await DataBaseManager().update_meal(meal_id, meal)


@meals.delete("/{meal_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_meal(meal_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await meal_exists(meal_id):
        raise MealNotFound()
    await DataBaseManager().delete_meal(meal_id)
