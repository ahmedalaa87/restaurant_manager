from pydantic import BaseModel


class Major(BaseModel):
    id: int
    name: str


class MajorIn(BaseModel):
    name: str


class MajorOut(BaseModel):
    id: int
    name: str


class MajorUpdate(BaseModel):
    name: str