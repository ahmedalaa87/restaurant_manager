class StudentModel {
  final int id;
  final String name;
  final int entryYear;
  final int majorId;

  StudentModel({required this.id, required this.name, required this.entryYear, required this.majorId});

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
    id: json["id"],
    name: json["name"],
    entryYear: json["entry_year"],
    majorId: json["major_id"],
  );
}