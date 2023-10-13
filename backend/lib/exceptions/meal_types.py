from fastapi import HTTPException, status


class MealTypeNotFound(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Meal type not found")


class MealWithTypeAlreadyCreatedToday(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="A meal with this type has been created today")


class MealTypeAlreadyExists(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="Meal type already exists")
