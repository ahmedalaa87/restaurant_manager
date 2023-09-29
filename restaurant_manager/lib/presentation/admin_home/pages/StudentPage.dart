import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';
import 'package:restaurant_manager/presentation/shared/widgets/PropertyHolder.dart';
import 'package:restaurant_manager/presentation/shared/widgets/custom_button.dart';

class StudentPageArgs {
  final StudentModel student;

  StudentPageArgs({required this.student});
}

class StudentPage extends StatelessWidget {
  final StudentModel student;
  const StudentPage({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsCubit, StudentsState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is StudentsErrorState) {
          context.showSnackBar(state.message, Colors.red);
        }

        if (state is MarkStudentAsAbsentSuccessState) {
          context.showSnackBar("Student marked as absent", Colors.green);
        }

        if (state is MarkStudentAsStayerSuccessState) {
          context.showSnackBar("Student marked as stayer", Colors.green);
        }

        if (state is UnMarkStudentAsAbsentSuccessState) {
          context.showSnackBar("Student unmarked as absent", Colors.green);
        }

        if (state is UnMarkStudentAsStayerSuccessState) {
          context.showSnackBar("Student unmarked as stayer", Colors.green);
        }
      },
      builder: (context, state) {
        StudentsCubit studentsCubit = context.read();

        return Scaffold(
          appBar: AppBar(
            title: Text("Student #${student.id}"),
            backgroundColor: context.colorScheme.primary,
            centerTitle: true,
            titleTextStyle: context.theme.textTheme.headlineMedium
                ?.copyWith(color: context.colorScheme.onPrimary),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PropertyHolder(
                  propertyName: "Name",
                  data: student.name,
                  isTitle: true,
                ),
                PropertyHolder(
                  propertyName: "Grade",
                  data: student.gradeYear.toString(),
                  isTitle: true,
                ),
                SizedBox(
                  height: 40.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      callback: () {
                        studentsCubit.markStudentAsAbsent(student.id);
                      },
                      text: "Mark as absent",
                      isLoading: state is StudentsLoadingState,
                    ),
                    CustomButton(
                      callback: () {
                        studentsCubit.unMarkStudentAsAbsent(student.id);
                      },
                      text: "UnMark as absent",
                      isLoading: state is StudentsLoadingState,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      callback: () {
                        studentsCubit.markStudentAsStayer(student.id);
                      },
                      text: "Mark as stayer",
                      isLoading: state is StudentsLoadingState,
                    ),
                    CustomButton(
                      callback: () {
                        studentsCubit.unMarkStudentAsStayer(student.id);
                      },
                      text: "UnMark as stayer",
                      isLoading: state is StudentsLoadingState,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
