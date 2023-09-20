from datetime import datetime, timedelta
from passlib.context import CryptContext
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from lib.authentication.fetching_users_manager import FetchingUsersManager
from lib.singleton_handler import Singleton
from lib.exceptions.auth import InvalidCredentials


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


class Authentication(metaclass=Singleton):
    def __init__(self,
                access_token_secret_key: str,
                refresh_token_secret_key: str,
                algorithm: str,
                access_token_expire_minutes: int,
                refresh_token_expire_days: int) -> None:
        self.access_token_secret_key = access_token_secret_key
        self.refresh_token_secret_key = refresh_token_secret_key
        self.algorithm = algorithm
        self.access_token_expire_minutes = access_token_expire_minutes
        self.refresh_token_expire_days = refresh_token_expire_days
        
    @staticmethod
    def verify_password(plain_password, hashed_password) -> bool:
        return pwd_context.verify(plain_password, hashed_password)
    
    @staticmethod
    def get_password_hash(password) -> str:
        return pwd_context.hash(password)
    
    def create_access_token(self, data: dict) -> str:
        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(minutes=self.access_token_expire_minutes)
        to_encode["exp"] = expire.timestamp()
        encoded_jwt = jwt.encode(to_encode, self.access_token_secret_key, algorithm=self.algorithm)
        return encoded_jwt
    
    def create_refresh_token(self, data: dict) -> str:
        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(days=self.refresh_token_expire_days)
        to_encode["exp"] = expire.timestamp()
        encoded_jwt = jwt.encode(to_encode, self.refresh_token_secret_key, algorithm=self.algorithm)
        return encoded_jwt
    
    def get_token_data(self, token: str, secret_key: str) -> dict:
        try:
            payload = jwt.decode(token, secret_key, algorithms=[self.algorithm])
            id = payload.get("id")
            if id is None:
                raise InvalidCredentials()
        except JWTError:
            raise InvalidCredentials()
        return payload
    
    def refresh_token(self, refresh_token: str) -> str:
        payload = self.get_token_data(refresh_token, self.refresh_token_secret_key)
        access_token = self.create_access_token(payload)
        new_refresh_token = self.create_refresh_token(payload)
        return access_token, new_refresh_token
    

async def get_current_user(*roles:str, token: str = Depends(oauth2_scheme)) -> dict:
    payload = Authentication().get_token_data(token, Authentication().access_token_secret_key)
    return await FetchingUsersManager.fetch_user(roles, payload)