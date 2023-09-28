from pydantic import BaseModel, EmailStr


class OwnerBase(BaseModel):
    name: str
    email: EmailStr


class OwnerOut(OwnerBase):
    id: int

    class Config:
        orm_mode = True