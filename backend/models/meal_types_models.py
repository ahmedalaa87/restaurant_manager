from pydantic import BaseModel


class MealTypeIn(BaseModel):
    name: str


class MealTypeOut(BaseModel):
    id: int
    name: str


class MealTypeUpdate(BaseModel):
    name: str
