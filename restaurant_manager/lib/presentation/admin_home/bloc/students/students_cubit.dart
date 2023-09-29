import 'package:bloc/bloc.dart';
import 'package:restaurant_manager/application/services/students/IStudentService.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_states.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final IStudentService studentService;
  int currentPage = 1;
  bool moreStudents = true;
  List<StudentModel> students = [];

  StudentsCubit({
    required this.studentService,
  }) : super(StudentsInitialState());

  Future<void> getStudents() async {
    emit(GetStudentsLoadingState());
    final response = await studentService.getStudents(currentPage);

    response.fold((failure) {
      emit(GetStudentsErrorState(failure.message));
    }, (students) {
      for (final student in students) {
        if (!this.students.contains(student)) {
          this.students.add(student);
        }
      }
      currentPage += 1;
      if (students.isEmpty) {
        moreStudents = false;
      }
      emit(GetStudentsSuccessState());
    });
  }

  Future<void> queryStudents(String query) async {
    final response = await studentService.queryStudents(query.toLowerCase());
    emit(QueryStudentsLoadingState());

    response.fold(
      (failure) {
        emit(
          QueryStudentsErrorState(
            failure.message,
          ),
        );
      },
      (students) {
        students.sort();
        for (final student in students) {
          if (!this.students.contains(student)) {
            this.students.add(student);
          }
        }
        emit(QueryStudentsSuccessState());
      },
    );
  }

  bool canLoadMore() {
    return moreStudents;
  }

  void clear() {
    moreStudents = true;
    students.clear();
    currentPage = 1;
  }
}
