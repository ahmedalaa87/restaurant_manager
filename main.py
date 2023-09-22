from fastapi import FastAPI
from lib.authentication.authentication import Authentication
from lib.database.manager import DataBaseManager
from routers import majors, students, meal_types, meals, admins, absences, owners
from lib.sunday_event_handler.sunday_event import EverySundayResetWillStayColumn
from models.settings_models import Settings
import datetime
from fastapi_pagination import add_pagination

app = FastAPI()
app.include_router(majors.majors)
app.include_router(students.students)
app.include_router(meal_types.meal_types)
app.include_router(meals.meals)
app.include_router(admins.admins)
app.include_router(absences.absences)
app.include_router(owners.owners)

add_pagination(app)

settings = Settings()

DataBaseManager("sqlite:///database.db")
Authentication(
    settings.access_token_secret_key,
    settings.refresh_token_secret_key,
    settings.algorithm,
    settings.access_token_expire_minutes,
    settings.refresh_token_expire_days
)

@app.on_event("startup")
async def startup():
    await DataBaseManager().connect()
    EverySundayResetWillStayColumn()
    if datetime.datetime.utcnow().weekday() == 6:
        await DataBaseManager().reset_will_stay_column()

@app.on_event("shutdown")
async def shutdown():
    await DataBaseManager().disconnect()