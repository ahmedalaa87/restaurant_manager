from fastapi import HTTPException, status


class AbsenceNotFound(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Absence not found")


class StudentIsAlreadyAbsentToday(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student is already absent today")


class StudentIsAlreadyAbsentAtDate(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student is already absent at date")


class StudentNotFount(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")


class StudentIsNotAbsentToday(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student is not absent today")


class StudentIsNotAbsentAtDate(HTTPException):
    def __init__(self, date: str):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student is not absent at date: " + date)
