from __future__ import annotations
from typing import TYPE_CHECKING
from databases import Database
from sqlalchemy import create_engine, MetaData

from lib.database.models import DbModels
from lib.singleton_handler import Singleton

if TYPE_CHECKING:
    from models.majors_models import MajorIn, MajorOut, MajorUpdate
    from models.students_models import Student, StudentIn
    from models.meal_types_models import MealTypeIn, MealTypeOut
    from models.meals_models import MealIn, MealOut
    from models.admins_models import AdminIn, Admin
    from models.absences_models import AbsenceIn, Absence
    from models.owners_models import OwnerOut
    

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

    async def get_meal_type_by_id(self, meal_type_id: int) -> MealTypeOut:
        query = self.models.meal_types.select().where(self.models.meal_types.c.id == meal_type_id)
        return await self.db.fetch_one(query)
    
    async def create_meal_type(self, meal_type: MealTypeIn) -> int:
        query = self.models.meal_types.insert().values(**meal_type.dict())
        return await self.db.execute(query)
    
    async def get_all_meal_types(self) -> list[MealTypeOut]:
        query = self.models.meal_types.select()
        return await self.db.fetch_all(query)
    
    async def update_meal_type(self, meal_type_id: int, meal_type: MealTypeIn) -> MealTypeOut:
        query = self.models.meal_types.update().where(self.models.meal_types.c.id == meal_type_id).values(**meal_type.dict())
        return await self.db.execute(query)
    
    async def delete_meal_type(self, meal_type_id: int) -> None:
        query = self.models.meal_types.delete().where(self.models.meal_types.c.id == meal_type_id)
        await self.db.execute(query)

    async def create_meal(self, meal: MealIn) -> int:
        query = self.models.meals.insert().values(**meal.dict())
        return await self.db.execute(query)
    
    async def get_meal(self, meal_id: int) -> MealOut:
        query = self.models.meals.select().where(self.models.meals.c.id == meal_id)
        return await self.db.fetch_one(query)
    
    async def get_all_meals(self) -> list[MealOut]:
        query = self.models.meals.select()
        return await self.db.fetch_all(query)
    
    async def update_meal(self, meal_id: int, meal: MealIn) -> MealOut:
        query = self.models.meals.update().where(self.models.meals.c.id == meal_id).values(**meal.dict())
        return await self.db.execute(query)
    
    async def delete_meal(self, meal_id: int) -> None:
        query = self.models.meals.delete().where(self.models.meals.c.id == meal_id)
        await self.db.execute(query)

    async def get_student_meals(self, student_id: int) -> list[MealOut]:
        query = self.models.meals.select().where(self.models.meals.c.student_id == student_id)
        return await self.db.fetch_all(query)
    
    async def get_student_meals_by_date(self, student_id: int, date: str = None) -> list[MealOut]:
        query = f"""
        SELECT *, :date FROM meals WHERE meals.student_id = :student_id AND DATE(meals.date_time) = {'DATE()' if not date else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_all(query=query, values={"student_id": student_id, "date": date})
    
    async def get_student_meals_by_meal_type(self, student_id: int, meal_type_id: int) -> list[MealOut]:
        query = self.models.meals.select().where(self.models.meals.c.student_id == student_id and self.models.meals.c.meal_type_id == meal_type_id)
        return await self.db.fetch_all(query)
    
    async def get_student_meal_by_date_and_meal_type(self, student_id: int, meal_type_id: int, date: str = None) -> MealOut:
        query = f"""
        SELECT *, :date FROM meals WHERE meals.student_id = :student_id AND meals.meal_type_id = :meal_type_id AND DATE(meals.date_time) = {'DATE()' if not date else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_one(query=query, values={"student_id": student_id, "meal_type_id": meal_type_id, "date": date})
    
    async def get_student_meals_by_date_and_meal_type(self, student_id: int, meal_type_id: int, date: str = None) -> list[MealOut]:
        query = f"""
        SELECT *, :date FROM meals WHERE meals.student_id = :student_id AND meals.meal_type_id = :meal_type_id AND DATE(meals.date_time) = {'DATE()' if not date else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_all(query=query, values={"student_id": student_id, "meal_type_id": meal_type_id, "date": date})
    
    async def get_meals_by_date_and_meal_type(self, meal_type_id: int, date: str = None) -> list[MealOut]:
        query = f"""
        SELECT *, :date FROM meals WHERE meals.meal_type_id = :meal_type_id AND DATE(meals.date_time) = {'DATE()' if not date else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_all(query=query, values={"meal_type_id": meal_type_id, "date": date})
    
    async def get_meals_count_by_date_and_meal_type(self, meal_type_id: int, date: str = None) -> int:
        query = f"""
        SELECT COUNT(*) FROM meals WHERE meals.meal_type_id = :meal_type_id AND DATE(meals.date_time) = {'DATE()' if not date else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_val(query=query, values={"meal_type_id": meal_type_id, "date": date})
    
    async def create_admin(self, admin: AdminIn) -> int:
        query = self.models.admins.insert().values(**admin.dict())
        return await self.db.execute(query)
    
    async def get_admin(self, id_or_email: int | str) -> Admin | None:
        if isinstance(id_or_email, int):
            query = self.models.admins.select().where(self.models.admins.c.id == id_or_email)
        else:
            query = self.models.admins.select().where(self.models.admins.c.email == id_or_email)
        return await self.db.fetch_one(query)
    
    async def get_all_admins(self) -> list[Admin]:
        query = self.models.admins.select()
        return await self.db.fetch_all(query)
    
    async def update_admin(self, admin_id: int, **fields) -> None:
        query = self.models.admins.update().where(self.models.admins.c.id == admin_id).values(**fields)
        await self.db.execute(query)

    async def delete_admin(self, admin_id: int) -> None:
        query = self.models.admins.delete().where(self.models.admins.c.id == admin_id)
        await self.db.execute(query)

    async def set_student_as_absent_today(self, absence: AbsenceIn) -> int:
        query = self.models.absences.insert().values(**absence.dict())
        return await self.db.execute(query)
    
    async def get_student_absence_by_date(self, student_id: int, date: str = None) -> Absence:
        query = f"""
        SELECT *, :date FROM absences WHERE absences.student_id = :student_id AND absences.date = {'DATE()' if not date else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_one(query=query, values={"student_id": student_id, "date": date})
    
    async def get_absence(self, absence_id: int) -> Absence:
        query = self.models.absences.select().where(self.models.absences.c.id == absence_id)
        return await self.db.fetch_one(query)
    
    async def get_all_absences(self) -> list[Absence]:
        query = self.models.absences.select()
        return await self.db.fetch_all(query)
    
    async def delete_absence(self, absence_id: int) -> None:
        query = self.models.absences.delete().where(self.models.absences.c.id == absence_id)
        return await self.db.execute(query)

    async def delete_student_today_absence(self, student_id: int) -> None:
        query = "DELETE FROM absences WHERE absences.student_id = :student_id AND absences.date = DATE();"
        return await self.db.execute(query=query, values={"student_id": student_id})
    
    async def delete_student_absence_at_date(self, student_id: int, date: str) -> None:
        query = "DELETE FROM absences WHERE absences.student_id = :student_id AND absences.date = STRFTIME(:date);"
        return await self.db.execute(query=query, values={"student_id": student_id, "date": date})
    
    async def get_owner(self, id_or_email: int | str) -> OwnerOut | None:
        query = f"""
        SELECT *  FROM owners WHERE {'owners.email = :id_or_email' if isinstance(id_or_email, str) else 'owners.id = :id_or_email'}
        """
        return await self.db.fetch_one(query, {"id_or_email": id_or_email})
    
    async def reset_will_stay_column(self) -> None:
        query = "UPDATE students SET will_stay = 0;"
        await self.db.execute(query)
    
    async def set_will_stay(self, student_id: int) -> None:
        query = "UPDATE students SET will_stay = 1 WHERE students.id = :student_id;"
        await self.db.execute(query, {"student_id": student_id})

    async def set_will_not_stay(self, student_id: int) -> None:
        query = "UPDATE students SET will_stay = 0 WHERE students.id = :student_id;"
        await self.db.execute(query, {"student_id": student_id})