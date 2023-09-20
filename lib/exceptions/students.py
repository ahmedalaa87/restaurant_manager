from fastapi import HTTPException, status


class StudentNotFound(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")


class RfidAlreadyExists(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_409_CONFLICT, detail="RFID already exists")


class CannotUpdateWillStay(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="Cannot update will stay on Thursday, Friday, Saturday or Sunday")


class StudentAlreadyStayer(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="Student is already a stayer")


class StudentIsNotStayer(HTTPException):
    def __init__(self):
        super().__init__(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="Student is not a stayer")