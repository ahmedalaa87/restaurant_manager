import 'package:restaurant_manager/application/errors/BaseError.dart';

class MealErrorMessages {
  static const String mealNotFoundError = "Meal not found";
  static const String mealTypeNotFound = "Invalid meal type";
}

class MealNotFoundError extends BaseError {
  MealNotFoundError() : super(MealErrorMessages.mealNotFoundError);
}

class MealTypeNotFoundError extends BaseError {
  MealTypeNotFoundError() : super(MealErrorMessages.mealTypeNotFound);
}

class AddStudentToMealBadRequestError extends BaseError {
  AddStudentToMealBadRequestError(super.message);
}