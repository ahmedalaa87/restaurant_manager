from pydantic import BaseModel
from datetime import date as DATE


class AbsenceIn(BaseModel):
    student_id: int
    date: DATE = DATE.today()


class AbsenceOut(BaseModel):
    id: int
    student_id: int
    date: DATE


class Absence(BaseModel):
    id: int
    student_id: int
    date: DATE