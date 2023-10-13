import 'package:dio/dio.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/end_points.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/exceptions.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/interceptors.dart';

import '../../domain/models/StudentModel.dart';
import '../auth/AuthInfo.dart';

abstract class IStudentDataProvider {
  Future<List<StudentModel>> getStudents(int page);

  Future<List<StudentModel>> queryStudents(String query);

  Future<void> markStudentAsAbsent(int id);

  Future<void> markStudentAsStayer(int id);

  Future<void> markStudentAsWeekAbsent(int id);

  Future<void> unMarkStudentAsAbsent(int id);

  Future<void> unMarkStudentAsStayer(int id);

  Future<void> unMarkStudentAsWeekAbsent(int id);
}

class StudentDataProvider implements IStudentDataProvider {
  late final Dio _dio;

  StudentDataProvider() {
    _dio = Dio(BaseOptions(
        baseUrl: EndPoints.serverUrl,
        connectTimeout: 2000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        validateStatus: (status) {
          return status != null && status < 500;
        }));

    _dio.interceptors.add(InterceptorsWrapper(onRequest: onRequestInterceptor));
  }

  @override
  Future<List<StudentModel>> getStudents(int page) async {
    try {
      final response = await _dio.get("/students/?page=$page",
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
      return meals.map(StudentModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> markStudentAsAbsent(int id) async {
    try {
      final response = await _dio.post("/absences/",
          data: {"student_id": id},
          options: Options(
            headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 409) {
        throw StudentIsAlreadyAbsentTodayException();
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> markStudentAsStayer(int id) async {
    try {
      final response = await _dio.put("/students/will_stay/$id",
          options: Options(
              headers: {
                "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
              }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 400) {
        throw CanNotUpdateStayersAtWeekendsException();
      }

      if (response.statusCode == 409) {
        throw StudentIsAlreadyMarkedAsStayerException();
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<StudentModel>> queryStudents(String query) async {
    try {
      final response = await _dio.get("/students/search/$query",
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
      return meals.map(StudentModel.fromJson).toList();
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> unMarkStudentAsAbsent(int id) async {
    try {
      final response = await _dio.delete("/absences/student/$id",
          options: Options(
              headers: {
                "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
              }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 409) {
        throw StudentIsNotAbsentTodayException();
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> unMarkStudentAsStayer(int id) async {
    try {
      final response = await _dio.put("/students/will_not_stay/$id",
          options: Options(
              headers: {
                "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
              }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 400) {
        throw CanNotUpdateStayersAtWeekendsException();
      }

      if (response.statusCode == 409) {
        throw StudentIsNotMarkedAsAStayerException();
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> unMarkStudentAsWeekAbsent(int id) async {
    try {
      final response = await _dio.put("/students/remove_week_absent/$id",
          options: Options(
              headers: {
                "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
              }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 400) {
        throw CanNotUpdateWeekAbsentsAtWeekendsException();
      }

      if (response.statusCode == 409) {
        throw StudentIsNotMarkedAsWeekAbsentException();
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> markStudentAsWeekAbsent(int id) async {
    try {
      final response = await _dio.put("/students/week_absent/$id",
          options: Options(
              headers: {
                "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
              }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      if (response.statusCode == 404) {
        throw StudentNotFoundException();
      }

      if (response.statusCode == 400) {
        throw CanNotUpdateWeekAbsentsAtWeekendsException();
      }

      if (response.statusCode == 409) {
        throw StudentIsAlreadyMarkedAsWeekAbsentException();
      }
    } on DioError {
      throw ServerException();
    }
  }

}