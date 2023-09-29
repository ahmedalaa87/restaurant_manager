class UserModel {
  final int id;
  final String name;
  final String role;
  final String email;

  UserModel({required this.id, required this.name, required this.role, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    role: json.containsKey("role") ? json["role"] : "student",
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role": role,
    "email": email,
  };
}