import 'package:restaurant_manager/application/errors/BaseError.dart';

class MealErrorMessages {
  static const String mealNotFoundError = "Meal not found";
}

class MealNotFoundError extends BaseError {
  MealNotFoundError() : super(MealErrorMessages.mealNotFoundError);
}