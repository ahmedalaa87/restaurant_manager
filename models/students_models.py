from pydantic import BaseModel


class Student(BaseModel):
    id: int
    rf_id: int
    name: str
    entry_year: int
    major_id: int


class StudentIn(BaseModel):
    rf_id: int
    name: str
    entry_year: int
    major_id: int


class StudentOut(BaseModel):
    id: int
    rf_id: int
    name: str
    entry_year: int
    major_id: int


class StudentUpdate(BaseModel):
    rf_id: int
    name: str
    entry_year: int
    major_id: int


class StudentRfidOut(BaseModel):
    id: int
    name: str
    