from fastapi import FastAPI
from lib.database.manager import DataBaseManger
from routers import majors, students, meal_types, meals

app = FastAPI()
app.include_router(majors.majors)
app.include_router(students.students)
app.include_router(meal_types.meal_types)
app.include_router(meals.meals)

DataBaseManger("sqlite:///database.db")

@app.on_event("startup")
async def startup():
    await DataBaseManger().connect()

@app.on_event("shutdown")
async def shutdown():
    await DataBaseManger().disconnect()