from pydantic import BaseModel, EmailStr, validator


class Student(BaseModel):
    id: int
    name: str
    entry_year: int
    major_id: int
    email: EmailStr
    password: str

    class Config:
        orm_mode = True


class StudentIn(BaseModel):
    name: str
    entry_year: int
    major_id: int
    email: EmailStr
    password: str

    @validator('password', pre=True)
    def password_validator(cls, password: str):
        if len(password) < 6:
            raise ValueError('Password must be at least 6 characters')
        return password


class StudentOut(BaseModel):
    id: int
    name: str
    entry_year: int
    major_id: int
    email: EmailStr

    class Config:
        orm_mode = True


class StudentUpdate(BaseModel):
    name: str
    entry_year: int
    major_id: int
    email: EmailStr


class StudentPasswordUpdate(BaseModel):
    old_password: str
    new_password: str

    @validator('new_password', pre=True)
    def password_validator(cls, password: str):
        if len(password) < 6:
            raise ValueError('Password must be at least 6 characters')
        return password