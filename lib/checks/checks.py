from lib.database.manager import DataBaseManger


async def major_exists(major_id: int) -> bool:
    major = await DataBaseManger().get_major(major_id)
    return True if major else False

async def student_exists(student_id: int) -> bool:
    student = await DataBaseManger().get_student(student_id)
    return True if student else False

async def meal_type_exists(meal_type_id: int) -> bool:
    meal_type = await DataBaseManger().get_meal_type_by_id(meal_type_id)
    return True if meal_type else False

async def meal_exists(meal_id: int) -> bool:
    meal = await DataBaseManger().get_meal(meal_id)
    return True if meal else False

async def student_has_meal_type_today(student_id: int, meal_type_id: int) -> bool:
    meal = await DataBaseManger().get_student_meal_by_date_and_meal_type(student_id, meal_type_id)
    return True if meal else False

async def admin_exists(admin_id: int) -> bool:
    admin = await DataBaseManger().get_admin(admin_id)
    return True if admin else False