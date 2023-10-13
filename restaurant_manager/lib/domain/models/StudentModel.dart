import 'dart:math';
import 'package:equatable/equatable.dart';

import '../constatns/majors.dart';

class StudentModel extends Equatable {
  final int id;
  final String name;
  final int entryYear;
  final String major;

  const StudentModel({
    required this.id,
    required this.name,
    required this.entryYear,
    required this.major,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        id: json["id"],
        name: json["name"],
        entryYear: json["entry_year"],
        major: Majors.values
            .firstWhere((element) => element.id == json["major_id"])
            .name,
      );

  int get gradeYear {
    DateTime currentDate = DateTime.now().toUtc();
    int currentGrade = currentDate.year - entryYear;
    if (currentDate.month >= 9) {
      currentGrade += 1;
    }
    return min(currentGrade, 5);
  }

  @override
  List<Object?> get props => [id];
}
