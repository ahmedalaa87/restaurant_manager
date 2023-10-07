import 'package:dio/dio.dart';
import 'package:restaurant_manager/domain/constatns/mealTypes.dart';
import 'package:restaurant_manager/domain/models/MealModel.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/end_points.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/exceptions.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/interceptors.dart';

import '../../domain/models/StudentModel.dart';
import '../auth/AuthInfo.dart';

abstract class IMealsDataProvider {
  Future<List<MealModel>> getMeals(int page, MealTypes? mealTypes);
  Future<MealModel> getMeal(int id);
  Future<MealModel> createMeal(MealTypes mealType);
  Future<StudentModel> addStudentToMeal(int studentId, int mealId);
}

class MealsDataProvider extends IMealsDataProvider {
  late final Dio _dio;

  MealsDataProvider() {
    _dio = Dio(BaseOptions(
        baseUrl: EndPoints.meals,
        connectTimeout: 2000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        validateStatus: (status) {
          return status != null && status < 500;
        }));

    _dio.interceptors.add(InterceptorsWrapper(onRequest: onRequestInterceptor));
  }

  @override
  Future<MealModel> getMeal(int id) async {
    try {
      final response = await _dio.get("/$id",
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw MealNotFoundException();
      }

      return MealModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<MealModel>> getMeals(int page, MealTypes? mealTypes) async {
    try {
      final response = await _dio.get(mealTypes == null ? "/?page=$page" : "/meal_type/${mealTypes.id}?page=$page",
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }
      if (response.data["items"] == null) {
        return [];
      }

      List<Map<String, dynamic>> meals = (response.data["items"] as List).cast<Map<String, dynamic>>();
      return meals.map(MealModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<MealModel> createMeal(MealTypes mealType) async {
    try {
      final response = await _dio.post("/",
          data: {"meal_type_id": mealType.id},
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw MealTypeNotFoundException();
      }

      if (response.statusCode == 409) {
        throw MealWithTypeAlreadyCreatedTodayExecption();
      }

      return MealModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<StudentModel> addStudentToMeal(int studentId, int mealId) async {
    try {
      final response = await _dio.put("/add_student",
          data: {
            "student_id": studentId,
            "meal_id": mealId
          },
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 400) {
        throw AddStudentToMealBadRequestException(response.data["detail"]);
      }

      return StudentModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

}