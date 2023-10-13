class StudentsState {}

class StudentsInitialState extends StudentsState {}

class StudentsLoadingState extends StudentsState {}

class StudentsErrorState extends StudentsState {
  final String message;

  StudentsErrorState(this.message);
}

class StudentsSuccessState extends StudentsState {}

class GetStudentsLoadingState extends StudentsLoadingState {}

class GetStudentsErrorState extends StudentsErrorState {
  GetStudentsErrorState(String message) : super(message);
}

class GetStudentsSuccessState extends StudentsSuccessState {}

class QueryStudentsLoadingState extends StudentsLoadingState {}

class QueryStudentsErrorState extends StudentsErrorState {
  QueryStudentsErrorState(String message) : super(message);
}

class QueryStudentsSuccessState extends StudentsSuccessState {}

class MarkStudentAsAbsentLoadingState extends StudentsLoadingState {}

class MarkStudentAsAbsentErrorState extends StudentsErrorState {
  MarkStudentAsAbsentErrorState(String message) : super(message);
}

class MarkStudentAsAbsentSuccessState extends StudentsSuccessState {}

class MarkStudentAsStayerLoadingState extends StudentsLoadingState {}

class MarkStudentAsStayerErrorState extends StudentsErrorState {
  MarkStudentAsStayerErrorState(String message) : super(message);
}

class MarkStudentAsStayerSuccessState extends StudentsSuccessState {}

class UnMarkStudentAsStayerLoadingState extends StudentsLoadingState {}

class UnMarkStudentAsStayerErrorState extends StudentsErrorState {
  UnMarkStudentAsStayerErrorState(String message) : super(message);
}

class UnMarkStudentAsStayerSuccessState extends StudentsSuccessState {}

class UnMarkStudentAsAbsentLoadingState extends StudentsLoadingState {}

class UnMarkStudentAsAbsentErrorState extends StudentsErrorState {
  UnMarkStudentAsAbsentErrorState(String message) : super(message);
}

class UnMarkStudentAsAbsentSuccessState extends StudentsSuccessState {}

class UnMarkStudentAsWeekAbsentLoadingState extends StudentsLoadingState {}

class UnMarkStudentAsWeekAbsentErrorState extends StudentsErrorState {
  UnMarkStudentAsWeekAbsentErrorState(String message) : super(message);
}

class UnMarkStudentAsWeekAbsentSuccessState extends StudentsSuccessState {}

class MarkStudentAsWeekAbsentLoadingState extends StudentsLoadingState {}

class MarkStudentAsWeekAbsentErrorState extends StudentsErrorState {
  MarkStudentAsWeekAbsentErrorState(String message) : super(message);
}

class MarkStudentAsWeekAbsentSuccessState extends StudentsSuccessState {}