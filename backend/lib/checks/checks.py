from lib.database.manager import DataBaseManager


async def major_exists(major_id: int) -> bool:
    major = await DataBaseManager().get_major(major_id)
    return True if major else False

async def student_exists(student_id: int) -> bool:
    student = await DataBaseManager().get_student(student_id)
    return True if student else False

async def meal_type_exists(meal_type_id: int) -> bool:
    meal_type = await DataBaseManager().get_meal_type_by_id(meal_type_id)
    return True if meal_type else False

async def meal_exists(meal_id: int) -> bool:
    meal = await DataBaseManager().get_meal(meal_id)
    return True if meal else False

async def meal_student_exists(meal_student_id: int) -> bool:
    meal_student = await DataBaseManager().get_meal_student(meal_student_id)
    return True if meal_student else False

async def student_has_meal_today(student_id: int, meal_id: int) -> bool:
    meal = await DataBaseManager().get_student_meal(student_id, meal_id)
    return True if meal else False

async def admin_exists(admin_id: int) -> bool:
    admin = await DataBaseManager().get_admin(admin_id)
    return True if admin else False

async def absence_exists(absence_id: int) -> bool:
    absence = await DataBaseManager().get_absence(absence_id)
    return True if absence else False

async def student_is_absent_today(student_id: int) -> bool:
    absence = await DataBaseManager().get_student_absence_by_date(student_id)
    return True if absence else False

async def student_is_absent_at_date(student_id: int, date: str) -> bool:
    absence = await DataBaseManager().get_student_absence_by_date(student_id, date)
    return True if absence else False

async def student_is_stayer(student_id: int) -> bool:
    student = await DataBaseManager().get_student(student_id)
    return True if student.will_stay else False

async def student_is_week_absent(student_id: int) -> bool:
    student = await DataBaseManager().get_student(student_id)
    return student.week_absent

async def meal_type_created_today(meal_type: int) -> bool:
    meal = await DataBaseManager().get_meal_by_date_and_meal_type(meal_type)
    return meal is not None