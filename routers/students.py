from fastapi import APIRouter, status, Depends, Query
from lib.authentication.authentication import oauth2_scheme, get_current_user
from models.students_models import StudentIn, StudentOut, StudentUpdate, StudentRfidOut
from lib.database.manager import DataBaseManager
from sqlite3 import IntegrityError
from lib.checks.checks import student_exists, student_is_stayer
from lib.exceptions.students import StudentNotFound, RfidAlreadyExists, CannotUpdateWillStay, StudentAlreadyStayer, StudentIsNotStayer
from lib.exceptions.majors import MajorNotFound
import datetime
from fastapi_pagination import Page

students = APIRouter(
    prefix="/students",
    tags=["students"]
)

Page = Page.with_custom_options(size= Query(20, ge=1, le=400))


@students.post("/", response_model=StudentOut, status_code=status.HTTP_201_CREATED)
async def create_student(student: StudentIn, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    major = await DataBaseManager().get_major(student.major_id)
    if not major:
        raise MajorNotFound()
    
    try:
        student_id = await DataBaseManager().create_student(student)

    except IntegrityError:
        raise RfidAlreadyExists()
    
    return {**student.dict(), "id": student_id}


@students.get("/{student_id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    student = await DataBaseManager().get_student(student_id)
    if not student:
        raise StudentNotFound()
    
    return student


@students.get("/rfid/{rf_id}", response_model=StudentRfidOut, status_code=status.HTTP_200_OK)
async def get_student_by_rfid(rf_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    student = await DataBaseManager().get_student_by_rfid(rf_id)
    if not student:
        raise StudentNotFound()
    
    return student


@students.get("/", response_model=Page[StudentOut], status_code=status.HTTP_200_OK)
async def get_all_students(token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    return await DataBaseManager().get_all_students()


@students.put("/{student_id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def update_student(student_id: int, student: StudentUpdate, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    await DataBaseManager().update_student(student_id, student)
    return {**student.dict(), "id": student_id}


@students.delete("/{student_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    await DataBaseManager().delete_student(student_id)


@students.get("/major/{major_id}", response_model=Page[StudentOut], status_code=status.HTTP_200_OK)
async def get_students_by_major(major_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    major = await DataBaseManager().get_major(major_id)
    if not major:
        raise MajorNotFound()
    
    return await DataBaseManager().get_students_by_major(major_id)


@students.put("/will_stay/{student_id}", status_code=status.HTTP_200_OK)
async def update_will_stay(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    if datetime.datetime.now().weekday() in [3, 4, 5, 6]:
        raise CannotUpdateWillStay()
    
    if await student_is_stayer(student_id):
        raise StudentAlreadyStayer()
        
    await DataBaseManager().set_will_stay(student_id)
    return {"message": "Student will stay"}


@students.put("/will_not_stay/{student_id}", status_code=status.HTTP_200_OK)
async def update_will_not_stay(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    if datetime.datetime.now().weekday() in [3, 4, 5, 6]:
        raise CannotUpdateWillStay()
    
    if not await student_is_stayer(student_id):
        raise StudentIsNotStayer()
        
    await DataBaseManager().set_will_not_stay(student_id)
    return {"message": "Student will not stay"}