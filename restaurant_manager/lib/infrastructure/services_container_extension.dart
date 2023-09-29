import 'package:get_it/get_it.dart';
import 'package:restaurant_manager/infrastructure/data_providers/AuthDataProvider.dart';
import 'package:restaurant_manager/infrastructure/data_providers/MealsDataProvider.dart';
import 'package:restaurant_manager/infrastructure/data_providers/StudentsDataProvider.dart';
import 'package:restaurant_manager/infrastructure/local_storage/CacheStorage.dart';
import 'package:restaurant_manager/infrastructure/network_status/network_status.dart';
extension InfrastructureServicesExtension on GetIt {
  void initInfrastructureServices() {
    registerLazySingleton<IAuthDataProvider>(() => AuthDataProvider());
    registerLazySingleton<IMealsDataProvider>(() => MealsDataProvider(),);
    registerLazySingleton<IStudentDataProvider>(() => StudentDataProvider(),);
    registerLazySingleton<ICacheStorage>(() => CacheStorage(this()));
    registerLazySingleton<INetworkStatus>(() => NetworkStatus(internetConnectionChecker: this()));
  }
}