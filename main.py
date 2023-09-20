from fastapi import FastAPI
from lib.database.manager import DataBaseManger
from routers import majors, students, meal_types, meals, admins, absences, owners
from lib.sunday_event_handler.sunday_event import EverySundayResetWillStayColumn
import datetime

app = FastAPI()
app.include_router(majors.majors)
app.include_router(students.students)
app.include_router(meal_types.meal_types)
app.include_router(meals.meals)
app.include_router(admins.admins)
app.include_router(absences.absences)
app.include_router(owners.owners)

DataBaseManger("sqlite:///database.db")

@app.on_event("startup")
async def startup():
    await DataBaseManger().connect()
    EverySundayResetWillStayColumn()
    if datetime.datetime.now().weekday() == 6:
        await DataBaseManger().reset_will_stay_column()

@app.on_event("shutdown")
async def shutdown():
    await DataBaseManger().disconnect()