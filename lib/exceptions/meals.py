from fastapi import HTTPException, status


class MealNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meal not found"
        )


class StudentAlreadyHasMeal(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Student already has this meal"
        )