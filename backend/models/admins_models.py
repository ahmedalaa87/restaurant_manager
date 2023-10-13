from pydantic import BaseModel, validator, EmailStr


class AdminIn(BaseModel):
    name: str
    role: str
    email: EmailStr
    password: str

    @validator('role', pre=True)
    def role_validator(cls, role: str):
        role = role.lower()
        if role not in ['teacher', 'cheif', 'manager']:
            raise ValueError('Role must be teacher, cheif or manager')
        return role
    
    @validator('password', pre=True)
    def password_validator(cls, password: str):
        if len(password) < 6:
            raise ValueError('Password must be at least 6 characters')
        return password
    

class AdminOut(BaseModel):
    id: int
    name: str
    role: str
    email: str

    class Config:
        orm_mode = True


class Admin(BaseModel):
    id: int
    name: str
    role: str
    email: str
    password: str

    class Config:
        orm_mode = True


class AdminUpdate(BaseModel):
    name: str
    role: str
    email: EmailStr

    @validator('role', pre=True)
    def role_validator(cls, role: str):
        role = role.lower()
        if role not in ['teacher', 'chief', 'manager']:
            raise ValueError('Role must be teacher, moderator or manager')
        return role
    

class AdminPasswordUpdate(BaseModel):
    old_password: str
    new_password: str

    @validator('new_password', pre=True)
    def password_validator(cls, password: str):
        if len(password) < 6:
            raise ValueError('Password must be at least 6 characters')
        return password
