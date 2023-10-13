import 'package:dartz/dartz.dart';
import 'package:restaurant_manager/application/errors/BaseError.dart';
import 'package:restaurant_manager/application/errors/SutdentErrors.dart';
import 'package:restaurant_manager/application/services/meals/IMealService.dart';
import 'package:restaurant_manager/domain/constatns/mealTypes.dart';
import 'package:restaurant_manager/domain/models/MealModel.dart';
import 'package:restaurant_manager/domain/models/StudentModel.dart';
import 'package:restaurant_manager/infrastructure/network_status/network_status.dart';

import '../../../infrastructure/auth/AuthInfo.dart';
import '../../../infrastructure/data_providers/MealsDataProvider.dart';
import '../../../infrastructure/data_providers/shared/exceptions.dart';
import '../../errors/AuthErrors.dart';
import '../../errors/GeneralErrors.dart';
import '../../errors/MealsErrors.dart';

class MealsService implements IMealsService {
  final IMealsDataProvider mealsDataProvider;
  final INetworkStatus networkStatus;

  MealsService({required this.mealsDataProvider, required this.networkStatus});

  @override
  Future<Either<BaseError, MealModel>> getMeal(int id) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      MealModel mealModel = await mealsDataProvider.getMeal(id);

      return Right(mealModel);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on MealNotFoundException {
      return Left(MealNotFoundError());
    }
  }

  @override
  Future<Either<BaseError, List<MealModel>>> getMeals(int page, MealTypes? mealType) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      List<MealModel> meals = await mealsDataProvider.getMeals(page, mealType);

      return Right(meals);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    }
  }

  @override
  Future<Either<BaseError, StudentModel>> addStudentToMeal(int studentId, int mealId, bool timestampProvided) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      StudentModel student = await mealsDataProvider.addStudentToMeal(studentId, mealId, timestampProvided);

      return Right(student);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on StudentNotFoundException {
      return Left(StudentNotFoundError());
    } on AddStudentToMealBadRequestException catch (e) {
      return Left(AddStudentToMealBadRequestError(e.message));
    }
  }

  @override
  Future<Either<BaseError, MealModel>> createMeal(MealTypes mealType) async {
    if (!await networkStatus.isConnected()) {
    return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
    return Left(InvalidAccessTokenError());
    }

    try {
    MealModel meal = await mealsDataProvider.createMeal(mealType);

    return Right(meal);
    } on ServerException {
    return Left(ServerError());
    } on InvalidRefreshTokenException {
    return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
    return Left(InvalidAccessTokenError());
    } on MealTypeNotFoundException {
      return Left(MealTypeNotFoundError());
    } on MealWithTypeAlreadyCreatedTodayException {
      return Left(MealWithTypeAlreadyCreatedTodayError());
    }
  }

}