import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_states.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../../router/routes.dart';
import '../../shared/widgets/DataCard.dart';
import '../../shared/widgets/loading_indicator.dart';

class StudentsPage extends StatelessWidget {
  const StudentsPage({Key? key}) : super(key: key);

  Future<void> refresh(BuildContext context) async {
    StudentsCubit studentsCubit = context.read();
    studentsCubit.clear();
    studentsCubit.getStudents();
  }

  @override
  Widget build(BuildContext context) {
    StudentsCubit studentsCubit = context.read();
    studentsCubit.getStudents();

    return BlocConsumer<StudentsCubit, StudentsState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is GetStudentsErrorState) {
          context.showSnackBar(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        List<StudentModel> students = studentsCubit.students;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Students Page"),
            backgroundColor: context.colorScheme.primary,
            centerTitle: true,
            titleTextStyle: context.theme.textTheme.headlineMedium
                ?.copyWith(color: context.colorScheme.onPrimary),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: Icon(
                  Icons.logout,
                  color: context.colorScheme.onPrimary,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.pushNamed(Routes.studentSearch);
                },
                icon: Icon(
                  Icons.search,
                  color: context.colorScheme.onPrimary,
                ),
              )
            ],
          ),
          body: state is GetStudentsLoadingState &&
                  studentsCubit.students.isEmpty
              ? const Center(child: LoadingIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    await refresh(context);
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: (_, index) {
                      bool isLastWidget = index == students.length - 1;

                      if (isLastWidget &&
                          studentsCubit.canLoadMore() &&
                          state is GetStudentsSuccessState) {
                        studentsCubit.getStudents();
                      }

                      Widget studentWidget =
                          DataCard.fromStudent(students[index], context);

                      if (state is GetStudentsLoadingState && isLastWidget) {
                        return Column(
                          children: [
                            studentWidget,
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: LoadingIndicator(),
                            )
                          ],
                        );
                      }
                      return studentWidget;
                    },
                    itemCount: students.length,
                  ),
                ),
        );
      },
    );
  }
}
