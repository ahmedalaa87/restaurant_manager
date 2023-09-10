from fastapi import FastAPI
from lib.database.manager import DataBaseManger

app = FastAPI()

DataBaseManger("sqlite:///database.db")

@app.on_event("startup")
async def startup():
    await DataBaseManger().connect()

@app.on_event("shutdown")
async def shutdown():
    await DataBaseManger().disconnect()