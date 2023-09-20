from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    access_token_secret_key: str
    refresh_token_secret_key: str
    algorithm: str
    access_token_expire_minutes: int
    refresh_token_expire_days: int

    class Config:
        env_file = ".env"