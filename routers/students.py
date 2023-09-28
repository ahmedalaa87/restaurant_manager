from fastapi import APIRouter, status, Depends, Query
from lib.authentication.authentication import Authentication, oauth2_scheme, get_current_user
from fastapi.security import OAuth2PasswordRequestForm
from models.students_models import StudentIn, StudentOut, StudentUpdate, StudentPasswordUpdate
from lib.database.manager import DataBaseManager
from sqlite3 import IntegrityError
from lib.checks.checks import student_exists, student_is_stayer
from lib.exceptions.students import StudentNotFound, EmailAlreadyExists, CannotUpdateWillStay, StudentAlreadyStayer, StudentIsNotStayer, WrongEmailOrPassword, WrongPassword
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
    
    student.password = Authentication().get_password_hash(student.password)
    try:
        student_id = await DataBaseManager().create_student(student)

    except IntegrityError:
        raise EmailAlreadyExists()
    
    return {**student.dict(), "id": student_id}


@students.get("/", response_model=Page[StudentOut], status_code=status.HTTP_200_OK)
async def get_all_students(token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    return await DataBaseManager().get_all_students()


@students.put("/{student_id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def update_student(student_id: int, student: StudentUpdate, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    await DataBaseManager().update_student(student_id, **student.dict())
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


@students.post("/login", status_code=status.HTTP_200_OK)
async def login_student(form_data: OAuth2PasswordRequestForm = Depends()):
    student = await DataBaseManager().get_student(form_data.username)
    if not student or not Authentication.verify_password(form_data.password, student.password):
        raise WrongEmailOrPassword()
    
    access_token = Authentication().create_access_token({"id": student.id, "role": "student"})
    refresh_token = Authentication().create_refresh_token({"id": student.id, "role": "student"})
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}


@students.post("/refresh", status_code=status.HTTP_200_OK)
async def refresh_student(token: str = Depends(oauth2_scheme)):
    access_token, refresh_token = Authentication().refresh_token(token)
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}


@students.get("/me", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_me(token: str = Depends(oauth2_scheme)):
    student = await get_current_user("student", token=token)
    return student


@students.get("/{student_id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_current_user("admin", token=token)
    student = await DataBaseManager().get_student(student_id)
    if not student:
        raise StudentNotFound()
    
    return student


@students.patch("/reset_password", status_code=status.HTTP_200_OK)
async def reset_password(password_schema: StudentPasswordUpdate, token: str = Depends(oauth2_scheme)):
    student = await get_current_user("student", token=token)
    if not Authentication.verify_password(password_schema.old_password, student.password):
        raise WrongPassword()
    
    new_password = Authentication().get_password_hash(password_schema.new_password)
    await DataBaseManager().update_student(student.id, password= new_password)
    return {"message": "Password updated successfully"}