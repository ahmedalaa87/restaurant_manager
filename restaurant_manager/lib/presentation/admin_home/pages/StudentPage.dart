import 'package:flutter/material.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';

class StudentPageArgs {
  final StudentModel student;

  StudentPageArgs({required this.student});
}

class StudentPage extends StatelessWidget {
  final StudentModel student;
  const StudentPage({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
