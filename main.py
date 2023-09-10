from fastapi import FastAPI
from lib.database.manager import DataBaseManger
from routers import majors, students

app = FastAPI()
app.include_router(majors.majors)
app.include_router(students.students)

DataBaseManger("sqlite:///database.db")

@app.on_event("startup")
async def startup():
    await DataBaseManger().connect()

@app.on_event("shutdown")
async def shutdown():
    await DataBaseManger().disconnect()