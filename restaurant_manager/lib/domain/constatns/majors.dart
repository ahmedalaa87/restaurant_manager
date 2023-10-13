enum Majors {
  electronics(1, "Electronics"),
  electricity(2, "Electricity"),
  mechanics(3, "Mechanics"),
  general(4, "General");

  const Majors(this.id, this.name);
  final int id;
  final String name;
}