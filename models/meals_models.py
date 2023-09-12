from pydantic import BaseModel
from datetime import datetime


class MealIn(BaseModel):
    student_id: int
    meal_type_id: int
    date_time: datetime = datetime.utcnow()


class MealOut(BaseModel):
    id: int
    student_id: int
    meal_type_id: int
    date_time: datetime


class MealUpdate(BaseModel):
    student_id: int
    meal_type_id: int
    date_time: datetime = datetime.utcnow()