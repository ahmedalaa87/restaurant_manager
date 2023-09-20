from fastapi import APIRouter, status
from models.students_models import StudentIn, StudentOut, StudentUpdate, StudentRfidOut
from lib.database.manager import DataBaseManger
from sqlite3 import IntegrityError
from lib.checks.checks import student_exists, student_is_stayer
from lib.exceptions.students import StudentNotFound, RfidAlreadyExists, CannotUpdateWillStay, StudentAlreadyStayer, StudentIsNotStayer
from lib.exceptions.majors import MajorNotFound
import datetime

students = APIRouter(
    prefix="/students",
    tags=["students"]
)


@students.post("/", response_model=StudentOut, status_code=status.HTTP_201_CREATED)
async def create_student(student: StudentIn):
    major = await DataBaseManger().get_major(student.major_id)
    if not major:
        raise MajorNotFound()
    
    try:
        student_id = await DataBaseManger().create_student(student)

    except IntegrityError:
        raise RfidAlreadyExists()
    
    return {**student.dict(), "id": student_id}


@students.get("/{student_id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student(student_id: int):
    student = await DataBaseManger().get_student(student_id)
    if not student:
        raise StudentNotFound()
    
    return student


@students.get("/rfid/{rf_id}", response_model=StudentRfidOut, status_code=status.HTTP_200_OK)
async def get_student_by_rfid(rf_id: int):
    student = await DataBaseManger().get_student_by_rfid(rf_id)
    if not student:
        raise StudentNotFound()
    
    return student


@students.get("/", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
async def get_all_students():
    return await DataBaseManger().get_all_students()


@students.put("/{student_id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def update_student(student_id: int, student: StudentUpdate):
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    await DataBaseManger().update_student(student_id, student)
    return {**student.dict(), "id": student_id}


@students.delete("/{student_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student(student_id: int):
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    await DataBaseManger().delete_student(student_id)


@students.get("/major/{major_id}", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
async def get_students_by_major(major_id: int):
    major = await DataBaseManger().get_major(major_id)
    if not major:
        raise MajorNotFound()
    
    return await DataBaseManger().get_students_by_major(major_id)


@students.put("/will_stay/{student_id}", status_code=status.HTTP_200_OK)
async def update_will_stay(student_id: int):
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    if datetime.datetime.now().weekday() in [3, 4, 5, 6]:
        raise CannotUpdateWillStay()
    
    if await student_is_stayer(student_id):
        raise StudentAlreadyStayer()
        
    await DataBaseManger().set_will_stay(student_id)
    return {"message": "Student will stay"}


@students.put("/will_not_stay/{student_id}", status_code=status.HTTP_200_OK)
async def update_will_not_stay(student_id: int):
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    if datetime.datetime.now().weekday() in [3, 4, 5, 6]:
        raise CannotUpdateWillStay()
    
    if not await student_is_stayer(student_id):
        raise StudentIsNotStayer()
        
    await DataBaseManger().set_will_not_stay(student_id)
    return {"message": "Student will not stay"}