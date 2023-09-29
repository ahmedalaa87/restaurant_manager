import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../shared/widgets/DataCard.dart';
import '../../shared/widgets/loading_indicator.dart';


class StudentsSearchPage extends StatefulWidget {
  const StudentsSearchPage({Key? key}) : super(key: key);

  @override
  State<StudentsSearchPage> createState() => _StudentsSearchPageState();
}

class _StudentsSearchPageState extends State<StudentsSearchPage> {
  late TextEditingController queryEditingController;

  @override
  void initState() {
    queryEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    queryEditingController.dispose();
    super.dispose();
  }

  void queryItems(BuildContext context) {
    if (queryEditingController.text.isEmpty) return;

    StudentsCubit itemsCubit = context.read<StudentsCubit>();
    itemsCubit.queryStudents(queryEditingController.text);
  }

  List<StudentModel> getQueryItems(StudentsCubit itemsCubit) {
    return itemsCubit.students
        .where(
          (item) =>
          item.name.toLowerCase().contains(queryEditingController.text.toLowerCase()),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsCubit, StudentsState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is QueryStudentsErrorState) {
          context.showSnackBar(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        StudentsCubit itemsCubit = context.read<StudentsCubit>();
        List<StudentModel> students = getQueryItems(itemsCubit);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.navigator.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
            ),
            title: TextFormField(
              controller: queryEditingController,
              onFieldSubmitted: (_) => queryItems(context),
              decoration: const InputDecoration(
                filled: false,
                border: UnderlineInputBorder(),
                hintText: "Enter your query",
              ),
              maxLines: 1,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  queryEditingController.text = "";
                },
                icon: const Icon(Icons.clear),
              ),
              IconButton(
                onPressed: () => queryItems(context),
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: state is QueryStudentsLoadingState
              ? const Center(child: LoadingIndicator())
              : ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (_, index) {
              return DataCard.fromStudent(
                students[index],
                context,
              );
            },
            itemCount: students.length,
          ),
        );
      },
    );
  }
}
