from fastapi import APIRouter, status, Depends
from lib.authentication.authentication import oauth2_scheme, get_current_user
from lib.checks.checks import meal_exists, student_exists, meal_type_exists, student_has_meal_type_today, student_is_absent_today, student_is_stayer
from models.meals_models import MealIn, MealOut
from lib.exceptions.meals import MealNotFound, StudentAlreadyHasMeal, StudentIsAbsent, StudentIsNotStayer
from lib.exceptions.students import StudentNotFound
from lib.exceptions.meal_types import MealTypeNotFound
from lib.database.manager import DataBaseManager
from datetime import date, datetime

meals = APIRouter(
    prefix="/meals",
    tags=["meals"]
)


@meals.post("/", response_model=MealOut, status_code=status.HTTP_201_CREATED)
async def create_meal(meal: MealIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await meal_type_exists(meal.meal_type_id):
        raise MealTypeNotFound()
    if not await student_exists(meal.student_id):
        raise StudentNotFound()
    if await student_has_meal_type_today(meal.student_id, meal.meal_type_id):
        raise StudentAlreadyHasMeal()
    if await student_is_absent_today(meal.student_id) and meal.meal_type_id == 2 and datetime.now().weekday() != 3:
        raise StudentIsAbsent()
    if datetime.now().weekday() == 3 and meal.meal_type_id in [2, 3] and not await student_is_stayer(meal.student_id):
        raise StudentIsNotStayer()
    if datetime.now().weekday() == 4 and not await student_is_stayer(meal.student_id):
        raise StudentIsNotStayer()
    if datetime.now().weekday() == 5 and meal.meal_type_id in [1, 2] and not await student_is_stayer(meal.student_id):
        raise StudentIsNotStayer()
    meal_id = await DataBaseManager().create_meal(meal)
    return {"id": meal_id, **meal.dict()}


@meals.post("/force", response_model=MealOut, status_code=status.HTTP_201_CREATED)
async def force_create_meal(meal: MealIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await meal_type_exists(meal.meal_type_id):
        raise MealTypeNotFound()
    if not await student_exists(meal.student_id):
        raise StudentNotFound()
    meal_id = await DataBaseManager().create_meal(meal)
    return {"id": meal_id, **meal.dict()}


@meals.get("/{meal_id}", response_model=MealOut)
async def get_meal(meal_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    meal = await DataBaseManager().get_meal(meal_id)
    if not meal:
        raise MealNotFound()
    return meal


@meals.get("/", response_model=list[MealOut])
async def get_all_meals(token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    return await DataBaseManager().get_all_meals()


@meals.put("/{meal_id}", response_model=MealOut)
async def update_meal(meal_id: int, meal: MealIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await meal_exists(meal_id):
        raise MealNotFound()
    await DataBaseManager().update_meal(meal_id, meal)
    return {"id": meal_id, **meal.dict()}


@meals.delete("/{meal_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_meal(meal_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await meal_exists(meal_id):
        raise MealNotFound()
    await DataBaseManager().delete_meal(meal_id)


@meals.get("/student/{student_id}", response_model=list[MealOut])
async def get_student_meals(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    return await DataBaseManager().get_student_meals(student_id)


@meals.get("/date/student/{student_id}", response_model=list[MealOut])
async def get_student_meals_by_date(student_id: int, date: date = None, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    return await DataBaseManager().get_student_meals_by_date(student_id, date)


@meals.get("/date/student/{student_id}/{meal_type_id}", response_model=MealOut)
async def get_student_meal_by_date_and_meal_type(student_id: int, meal_type_id: int, date: date = None, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    if not await meal_type_exists(meal_type_id):
        raise MealTypeNotFound()
    meal = await DataBaseManager().get_student_meal_by_date_and_meal_type(student_id, meal_type_id, date)
    if not meal:
        raise MealNotFound()
    return meal