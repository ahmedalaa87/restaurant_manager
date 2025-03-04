from fastapi import HTTPException, status


class StudentNotFound(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")


class EmailAlreadyExists(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="Email already exists")


class CannotUpdateWillStay(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot update will stay on Thursday, Friday, Saturday or Sunday")


class CannotUpdateWeekAbsent(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot update week absent on Thursday, Friday or Saturday")


class StudentAlreadyStayer(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="Student is already a stayer")

class StudentAlreadyWeekAbsented(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="Student is already seted as week absented")


class StudentNotWeekAbsented(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="Student is not seted as week absented")


class StudentIsNotStayer(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="Student is not a stayer")


class WrongEmailOrPassword(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_400_BAD_REQUEST, detail="Wrong email or password")


class WrongPassword(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_400_BAD_REQUEST, detail="Wrong password")