from lib.database.manager import DataBaseManger


async def major_exists(major_id: int):
    major = await DataBaseManger().get_major(major_id)
    return True if major else False

async def student_exists(student_id: int):
    student = await DataBaseManger().get_student(student_id)
    return True if student else False