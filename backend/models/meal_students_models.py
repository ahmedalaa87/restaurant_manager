from pydantic import BaseModel


class MealStudentIn(BaseModel):
    student_id: int
    meal_id: int


class MealStudentOut(BaseModel):
    id: int
    student_id: int
    meal_id: int


class MealStudentUpdate(BaseModel):
    student_id: int
    meal_id: int