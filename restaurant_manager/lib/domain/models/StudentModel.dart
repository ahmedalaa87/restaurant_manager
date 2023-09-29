import 'dart:math';
import 'package:equatable/equatable.dart';

class StudentModel extends Equatable {
  final int id;
  final String name;
  final int entryYear;

  StudentModel({required this.id, required this.name, required this.entryYear});

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    id: json["id"],
    name: json["name"],
    entryYear: json["entry_year"],
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