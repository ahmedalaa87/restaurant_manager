from fastapi import APIRouter, Depends, status, Query
from lib.authentication.authentication import oauth2_scheme, get_current_user
from fastapi_pagination import Page
from lib.database.manager import DataBaseManager
from lib.exceptions.meal_students import MealNotFound, StudentAlreadyHasMeal, StudentIsAbsent, StudentIsNotStayer, MealStudentNotFound
from lib.exceptions.students import StudentNotFound
from models.meal_students_models import MealStudentIn, MealStudentOut, MealStudentUpdate
from datetime import datetime
from lib.checks.checks import meal_exists, student_exists, student_has_meal_today, student_is_absent_today, student_is_stayer, meal_student_exists

meal_students = APIRouter(
    prefix="/meal_students",
    tags=["meal_students"]
)

Page = Page.with_custom_options(size= Query(20, ge=1, le=100000))

@meal_students.post("/", response_model=MealStudentOut, status_code=status.HTTP_201_CREATED)
async def create_meal_student(meal_student: MealStudentIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    meal = await DataBaseManager().get_meal(meal_student.meal_id)
    if not meal:
        raise MealNotFound()
    student = await DataBaseManager().get_student(meal_student.student_id)
    if not student:
        raise StudentNotFound()
    if await student_has_meal_today(meal_student.student_id, meal_student.meal_id):
        raise StudentAlreadyHasMeal()
    if await student_is_absent_today(meal_student.student_id) and meal.meal_type_id == 2 and datetime.now().weekday() != 3:
        raise StudentIsAbsent()
    if datetime.now().weekday() == 3 and meal.meal_type_id in [2, 3] and not await student_is_stayer(meal_student.student_id):
        raise StudentIsNotStayer()
    if datetime.now().weekday() == 4 and not await student_is_stayer(meal_student.student_id):
        raise StudentIsNotStayer()
    if datetime.now().weekday() == 5 and meal.meal_type_id in [1, 2] and not await student_is_stayer(meal_student.student_id):
        raise StudentIsNotStayer()
    meal_student_id = await DataBaseManager().create_meal_student(meal_student)
    return {"id": meal_student_id, **meal_student.dict()}

