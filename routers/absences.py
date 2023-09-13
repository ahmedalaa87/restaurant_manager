from fastapi import APIRouter, status
from lib.database.manager import DataBaseManger
from lib.exceptions.absences import AbsenceNotFound, StudentIsAlreadyAbsentToday, StudentNotFount, StudentIsNotAbsentToday, StudentIsNotAbsentAtDate
from models.absences_models import AbsenceIn, AbsenceOut
from lib.checks.checks import student_exists, student_is_absent_today, student_is_absent_at_date, absence_exists
from datetime import date

absences = APIRouter(
    prefix="/absences",
    tags=["Absences"]
)


@absences.post("/", response_model=AbsenceOut, status_code=status.HTTP_201_CREATED)
async def create_absence(absence: AbsenceIn):
    if not await student_exists(absence.student_id):
        raise StudentNotFount()
    if await student_is_absent_today(absence.student_id):
        raise StudentIsAlreadyAbsentToday()
    absence_id = await DataBaseManger().set_student_as_absent_today(absence)
    return {"id": absence_id, **absence.dict()}


@absences.get("/{absence_id}", response_model=AbsenceOut, status_code=status.HTTP_200_OK)
async def get_absence(absence_id: int):
    absence = await DataBaseManger().get_absence(absence_id)
    if not absence:
        raise AbsenceNotFound()
    return absence


@absences.delete("/{absence_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_absence(absence_id: int):
    if not await absence_exists(absence_id):
        raise AbsenceNotFound()
    await DataBaseManger().delete_absence(absence_id)


@absences.delete("/student/{student_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_absence_today(student_id: int):
    if not await student_exists(student_id):
        raise StudentNotFount()
    if not await student_is_absent_today(student_id):
        raise StudentIsNotAbsentToday()
    await DataBaseManger().delete_student_today_absence(student_id)


@absences.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_absence_at_date(student_id: int, date: date):
    if not await student_exists(student_id):
        raise StudentNotFount()
    if not await student_is_absent_at_date(student_id, date):
        raise StudentIsNotAbsentAtDate(str(date))
    await DataBaseManger().delete_student_absence_at_date(student_id, date)