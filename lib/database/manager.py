from __future__ import annotations
from typing import TYPE_CHECKING
from databases import Database
from sqlalchemy import create_engine, MetaData

from lib.database.models import DbModels
from lib.singleton_handler import Singleton


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
    
