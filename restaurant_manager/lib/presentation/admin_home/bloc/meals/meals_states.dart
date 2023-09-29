import '../../../../domain/models/MealModel.dart';

class MealsState {}

class MealsInitial extends MealsState {}

class MealsLoading extends MealsState {}

class MealsError extends MealsState {
  final String message;

  MealsError(this.message);
}

class GetAllMealsLoading extends MealsState {}

class GetAllMealsSuccess extends MealsState {}

class GetAllMealsError extends MealsState {
  final String message;

  GetAllMealsError(this.message);
}

class GetMealByIdLoading extends MealsState {}

class GetMealByIdSuccess extends MealsState {
  final MealModel meal;

  GetMealByIdSuccess({required this.meal});
}

class GetMealByIdError extends MealsState {
  final String message;

  GetMealByIdError(this.message);
}

