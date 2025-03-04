from __future__ import annotations
from typing import Callable, TYPE_CHECKING
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import InvalidCredentials

if TYPE_CHECKING:
    from models.admins_models import Admin
    from models.owners_models import OwnerOut
    from models.students_models import StudentOut


def role_fetcher_decorator(role_name: str) -> Callable:
    def decorator(func: Callable) -> Callable:
        async def wrapper(token_data: dict):
            role = token_data.get("role")
            if role != role_name:
                return None
            return await func(token_data)

        FetchingUsersManager(role_name, wrapper)
        return func

    return decorator


class FetchingUsersManager:
    __roles_fetchers__: dict[str, FetchingUsersManager] = {}
    __slots__ = ("role", "callback")

    def __init__(self, role: str, callback: Callable) -> None:
        self.role = role
        self.callback = callback
        self.__roles_fetchers__[role] = self

    @classmethod
    async def fetch_user(
        cls, roles: list[str], token_data: dict
    ) -> OwnerOut | Admin | None:
        for role in roles:
            fetcher = cls.__roles_fetchers__.get(role)
            if fetcher is None:
                continue

            user = await fetcher.callback(token_data)
            if user is None:
                continue

            return user


        raise InvalidCredentials()
    

@role_fetcher_decorator("owner")
async def fetch_owner(token_data: dict) -> OwnerOut | None:
    owner_id = token_data.get("id")
    owner = await DataBaseManager().get_owner(owner_id)

    return owner


@role_fetcher_decorator("admin")
async def fetch_admin(token_data: dict) -> Admin | None:
    admin_id = token_data.get("id")
    admin = await DataBaseManager().get_admin(admin_id)

    return admin


@role_fetcher_decorator("student")
async def fetch_student(token_data: dict) -> StudentOut | None:
    student_id = token_data.get("id")
    student = await DataBaseManager().get_student(student_id)

    return student