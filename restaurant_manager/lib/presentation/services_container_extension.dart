import 'package:get_it/get_it.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';

import 'admin_home/bloc/students/students_cubit.dart';

extension PresentationServicesExtension on GetIt {
  void initPresentationServices() {
    registerFactory<AuthCubit>(
      () => AuthCubit(
        authService: this(),
      ),
    );

    registerFactory<MealsCubit>(
      () => MealsCubit(
        mealsService: this(),
      ),
    );

    registerFactory<StudentsCubit>(
      () => StudentsCubit(
        studentService: this(),
      ),
    );
  }
}
