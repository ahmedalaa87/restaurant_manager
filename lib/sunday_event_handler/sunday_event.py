import asyncio
import datetime
from lib.database.manager import DataBaseManger
from lib.singleton_handler import Singleton

class EverySundayResetWillStayColumn(metaclass=Singleton):
    def __init__(self):
        asyncio.create_task(self._calculate_time_stamp_until_next_sunday())
    
    async def _calculate_time_stamp_until_next_sunday(self):
        now = datetime.datetime.utcnow()
        next_sunday = now + datetime.timedelta(days=6 - now.weekday())
        next_sunday_beginnig = datetime.datetime.combine(next_sunday, datetime.time.min)
        asyncio.create_task(self._update_will_stay_column(int((next_sunday_beginnig - now).total_seconds())))
    
    async def _update_will_stay_column(self, time_stamp: int):
        await asyncio.sleep(time_stamp)
        await DataBaseManger().reset_will_stay_column()
        await self._calculate_time_stamp_until_next_sunday()
        