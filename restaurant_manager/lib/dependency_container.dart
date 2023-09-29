import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:restaurant_manager/application/services_container_extension.dart';
import 'package:restaurant_manager/infrastructure/services_container_extension.dart';
import 'package:restaurant_manager/presentation/services_container_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt getIt = GetIt.instance;

Future<void> setUp() async {
  getIt.initInfrastructureServices();
  getIt.initApplicationServices();
  getIt.initPresentationServices();
  await _setUpCore();
}

Future<void> _setUpCore() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}