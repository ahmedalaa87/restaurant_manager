import 'package:get_it/get_it.dart';
import 'package:restaurant_manager/application/services/auth/AuthService.dart';
import 'package:restaurant_manager/application/services/auth/IAuthService.dart';
import 'package:restaurant_manager/application/services/meals/IMealService.dart';
import 'package:restaurant_manager/application/services/meals/MealsService.dart';
import 'package:restaurant_manager/application/services/students/IStudentService.dart';
import 'package:restaurant_manager/application/services/students/StudentService.dart';

extension ApplicationServicesExtension on GetIt {
  void initApplicationServices() {
    registerLazySingleton<IAuthService>(
      () => AuthService(
        authDataProvider: this(),
        cacheStorage: this(),
        networkStatus: this(),
      ),
    );

    registerLazySingleton<IMealsService>(
      () => MealsService(
        mealsDataProvider: this(),
        networkStatus: this(),
      ),
    );

    registerLazySingleton<IStudentService>(() => StudentService(
      studentDataProvider: this(),
      networkStatus: this(),
    ),);
  }
}
