import 'package:dartz/dartz.dart';

import '../../../domain/constatns/mealTypes.dart';
import '../../../domain/models/MealModel.dart';
import '../../errors/BaseError.dart';

abstract class IMealsService {
  Future<Either<BaseError, List<MealModel>>> getMeals(int page, MealTypes? mealType);
  Future<Either<BaseError, MealModel>> getMeal(int id);
}