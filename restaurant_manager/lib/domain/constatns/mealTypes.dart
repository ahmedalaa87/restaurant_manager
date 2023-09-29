enum MealTypes {
  breakfast(1, 'Breakfast'),
  lunch(2, 'Lunch'),
  dinner(3, 'Dinner');

  const MealTypes(this.id, this.name);
  final int id;
  final String name;
}