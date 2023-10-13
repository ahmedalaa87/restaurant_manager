from sqlalchemy import Date, DateTime, String, Integer, ForeignKey, MetaData, Table, Column, Boolean


class DbModels:
    __slots__ = ("metadata", "students", "absences", "majors", "admins", "owners", "meal_types", "meals", "meal_students")

    def __init__(self, metadata: MetaData) -> None:
        self.metadata = metadata
        self._create_all_tables()

    def _create_all_tables(self) -> None:
        self._create_students_table()
        self._create_absences_table()
        self._create_majors_table()
        self._create_admins_table()
        self._create_owners_table()
        self._create_meal_types_table()
        self._create_meals_table()
        self._create_meal_students_table()

    def _create_students_table(self) -> None:
        self.students = Table(
            "students",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("name", String),
            Column("entry_year", Integer),
            Column("major_id", ForeignKey("majors.id", ondelete="CASCADE")),
            Column("will_stay", Boolean, server_default="0"),
            Column("email", String, unique=True),
            Column("password", String),
            Column("week_absent", Boolean, server_default="0"),
            Column("ios", Boolean, server_default="0")
        )
    
    def _create_absences_table(self) -> None:
        self.absences = Table(
            "absences",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("student_id", ForeignKey("students.id", ondelete="CASCADE")),
            Column("date", Date)
        )
    
    def _create_majors_table(self) -> None:
        self.majors = Table(
            "majors",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("name", String, unique=True)
        )
    
    def _create_admins_table(self) -> None:
        self.admins = Table(
            "admins",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("name", String),
            Column("role", String),
            Column("email", String, unique=True),
            Column("password", String)
        )
    
    def _create_owners_table(self) -> None:
        self.owners = Table(
            "owners",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("name", String),
            Column("email", String, unique=True),
            Column("password", String)
        )
    
    def _create_meal_types_table(self) -> None:
        self.meal_types = Table(
            "meal_types",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("name", String, unique=True)
        )
    
    def _create_meals_table(self) -> None:
        self.meals = Table(
            "meals",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("meal_type_id", ForeignKey("meal_types.id", ondelete="CASCADE")),
            Column("date_time", DateTime)
        )
    
    def _create_meal_students_table(self) -> None:
        self.meal_students = Table(
            "meal_students",
            self.metadata,
            Column("id", Integer, primary_key=True),
            Column("meal_id", ForeignKey("meals.id", ondelete="CASCADE")),
            Column("student_id", ForeignKey("students.id", ondelete="CASCADE"))
        )