import 'package:restaurant_manager/application/errors/BaseError.dart';

class MealErrorMessages {
  static const String mealNotFoundError = "Meal not found";
  static const String mealTypeNotFound = "Invalid meal type";
  static const String mealWithTypeAlreadyCreatedToday = "A meal with this type has already been created today";
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

class MealWithTypeAlreadyCreatedTodayError extends BaseError {
  MealWithTypeAlreadyCreatedTodayError() : super(MealErrorMessages.mealWithTypeAlreadyCreatedToday);
}