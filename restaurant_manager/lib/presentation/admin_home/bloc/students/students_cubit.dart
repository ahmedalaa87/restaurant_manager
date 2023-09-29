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
    emit(QueryStudentsLoadingState());
    final response = await studentService.queryStudents(query.toLowerCase());

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

  void markStudentAsAbsent(int studentId) async {
    emit(MarkStudentAsAbsentLoadingState());
    final response = await studentService.markStudentAsAbsent(studentId);
    response.fold(
      (failure) {
        emit(MarkStudentAsAbsentErrorState(failure.message));
      },
      (success) {
        emit(MarkStudentAsAbsentSuccessState());
      },
    );
  }

  void markStudentAsStayer(int studentId) async {
    emit(MarkStudentAsStayerLoadingState());
    final response = await studentService.markStudentAsStayer(studentId);
    response.fold(
      (failure) {
        emit(MarkStudentAsStayerErrorState(failure.message));
      },
      (success) {
        emit(MarkStudentAsStayerSuccessState());
      },
    );
  }

  void unMarkStudentAsAbsent(int studentId) async {
    final response = await studentService.unMarkStudentAsAbsent(studentId);
    response.fold(
      (failure) {
        emit(UnMarkStudentAsAbsentErrorState(failure.message));
      },
      (success) {
        emit(UnMarkStudentAsAbsentSuccessState());
      },
    );
  }

  void unMarkStudentAsStayer(int studentId) async {
    emit(UnMarkStudentAsStayerLoadingState());
    final response = await studentService.unMarkStudentAsStayer(studentId);
    response.fold(
      (failure) {
        emit(UnMarkStudentAsStayerErrorState(failure.message));
      },
      (success) {
        emit(UnMarkStudentAsStayerSuccessState());
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
