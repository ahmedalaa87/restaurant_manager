from pydantic import BaseModel


class Student(BaseModel):
    id: int
    name: str
    entry_year: int
    major_id: int


class StudentIn(BaseModel):
    name: str
    entry_year: int
    major_id: int


class StudentOut(BaseModel):
    id: int
    name: str
    entry_year: int
    major_id: int


class StudentUpdate(BaseModel):
    name: str
    entry_year: int
    major_id: int