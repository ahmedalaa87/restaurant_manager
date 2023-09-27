from pydantic import BaseModel
from datetime import datetime


class MealIn(BaseModel):
    meal_type_id: int
    date_time: datetime = datetime.utcnow()


class MealOut(BaseModel):
    id: int
    meal_type_id: int
    date_time: datetime
    students_count: int = 0


class MealUpdate(BaseModel):
    meal_type_id: int
    date_time: datetime = datetime.utcnow()