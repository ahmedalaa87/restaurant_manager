import '../../../../domain/models/MealModel.dart';
import '../../../../domain/models/StudentModel.dart';

class MealsState {}

class MealsInitial extends MealsState {}

class MealsLoading extends MealsState {}

class MealsError extends MealsState {
  final String message;

  MealsError(this.message);
}

class GetAllMealsLoading extends MealsState {}

class GetAllMealsSuccess extends MealsState {}

class GetAllMealsError extends MealsError {

  GetAllMealsError(super.message);
}

class GetMealByIdLoading extends MealsState {}

class GetMealByIdSuccess extends MealsState {
  final MealModel meal;

  GetMealByIdSuccess({required this.meal});
}

class GetMealByIdError extends MealsError {

  GetMealByIdError(super.message);
}

class CreateMealLoadingState extends MealsState {}

class CreateMealSuccessState extends MealsState {
  final MealModel meal;

  CreateMealSuccessState({required this.meal});
}

class CreateMealErrorState extends MealsError {
  CreateMealErrorState(super.message);

}

class AddStudentToMealLoadingState extends MealsLoading {}

class AddStudentToMealSuccessState extends MealsState {
  final StudentModel student;

  AddStudentToMealSuccessState({required this.student});
}

class AddStudentToMealErrorState extends MealsError {
  AddStudentToMealErrorState(super.message);
}


