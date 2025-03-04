from pydantic import BaseModel, Field
from datetime import datetime


class MealIn(BaseModel):
    meal_type_id: int
    date_time: datetime = Field(default_factory=datetime.utcnow)


class MealStudent(BaseModel):
    id: int
    name: str
    entry_year: int
    major_id: int


class MealOut(BaseModel):
    id: int
    meal_type_id: int
    date_time: datetime
    students_count: int = 0
    students: list[MealStudent] = []


class MealUpdate(BaseModel):
    meal_type_id: int
    date_time: datetime = Field(default_factory=datetime.utcnow)