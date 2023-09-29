import 'package:restaurant_manager/domain/constatns/mealTypes.dart';

import 'StudentModel.dart';

class MealModel {
  final int id;
  final MealTypes mealType;
  final DateTime date;
  int studentCount;
  final List<StudentModel> students;

  MealModel(
      {required this.id,
      required this.mealType,
      required this.studentCount,
      required this.date,
      required this.students});

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json["id"],
      studentCount: json["students_count"],
      mealType: MealTypes.values
          .firstWhere((element) => element.id == json["meal_type_id"]),
      date: DateTime.parse(json["date_time"]).toUtc(),
      students: List<StudentModel>.from(
          json["students"].map((x) => StudentModel.fromJson(x))),
    );
  }
}
