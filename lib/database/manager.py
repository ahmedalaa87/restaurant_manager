from __future__ import annotations
from typing import TYPE_CHECKING
from databases import Database
from sqlalchemy import create_engine, MetaData

from lib.database.models import DbModels
from lib.singleton_handler import Singleton

if TYPE_CHECKING:
    from models.majors_models import MajorIn, MajorOut, MajorUpdate
    from models.students_models import Student, StudentIn, StudentUpdate
    

class DataBaseManger(metaclass=Singleton):
    def __init__(self, db_url: str) -> None:
        self.db_url = db_url
        self.db = Database(self.db_url)
        metadata = MetaData()
        self.models = DbModels(metadata)
        engine = create_engine(self.db_url, connect_args={"check_same_thread": False})
        metadata.create_all(engine)
    
    async def connect(self) -> None:
        await self.db.connect()
    
    async def disconnect(self) -> None:
        await self.db.disconnect()

    async def create_major(self, major: MajorIn) -> int:
        query = self.models.majors.insert().values(**major.dict())
        return await self.db.execute(query)
    
    async def get_major(self, major_id: int) -> MajorOut:
        query = self.models.majors.select().where(self.models.majors.c.id == major_id)
        return await self.db.fetch_one(query)
    
    async def get_all_majors(self) -> list[MajorOut]:
        query = self.models.majors.select()
        return await self.db.fetch_all(query)
    
    async def update_major(self, major_id: int, major: MajorUpdate) -> None:
        query = self.models.majors.update().where(self.models.majors.c.id == major_id).values(**major.dict())
        await self.db.execute(query)

    async def delete_major(self, major_id: int) -> None:
        query = self.models.majors.delete().where(self.models.majors.c.id == major_id)
        await self.db.execute(query)
    
    async def create_student(self, student: StudentIn) -> int:
        query = self.models.students.insert().values(**student.dict())
        return await self.db.execute(query)

    async def get_student(self, student_id: int) -> Student:
        query = self.models.students.select().where(self.models.students.c.id == student_id)
        return await self.db.fetch_one(query)
    
    async def get_student_by_rfid(self, rf_id: int) -> Student:
        query = self.models.students.select().where(self.models.students.c.rf_id == rf_id)
        return await self.db.fetch_one(query)
    
    async def get_students_by_major(self, major_id: int) -> list[Student]:
        query = self.models.students.select().where(self.models.students.c.major_id == major_id)
        return await self.db.fetch_all(query)
    
    async def get_all_students(self) -> list[Student]:
        query = self.models.students.select()
        return await self.db.fetch_all(query)
    
    async def update_student(self, student_id: int, student: StudentIn) -> None:
        query = self.models.students.update().where(self.models.students.c.id == student_id).values(**student.dict())
        await self.db.execute(query)

    async def delete_student(self, student_id: int) -> None:
        query = self.models.students.delete().where(self.models.students.c.id == student_id)
        await self.db.execute(query)

