import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../application/errors/AuthErrors.dart';
import '../presentation/admin_home/bloc/meals/meals_cubit.dart';
import '../presentation/admin_home/bloc/meals/meals_states.dart';
import '../presentation/authentication/bloc/authentication_cubit.dart';
import '../presentation/authentication/bloc/authentication_states.dart';
import '../router/routes.dart';

class DarkThemeWrapper extends StatelessWidget {
  final Widget child;
  const DarkThemeWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLogoutSuccessState) {
              context.pushNamedAndRemove(Routes.loginLanding);
            }

            if (state is AuthErrorState && (state.message == AuthErrorMessages.invalidAccessTokenError || state.message == AuthErrorMessages.invalidRefreshTokenError)) {
              context.pushNamedAndRemove(Routes.loginLanding);
            }
          },
        ),
        BlocListener<MealsCubit, MealsState>(
          listener: (context, state) {

            if (state is MealsError && (state.message == AuthErrorMessages.invalidAccessTokenError || state.message == AuthErrorMessages.invalidRefreshTokenError)) {
              context.pushNamedAndRemove(Routes.loginLanding);
            }
          },
        ),
        BlocListener<StudentsCubit, StudentsState>(
          listener: (context, state) {

            if (state is StudentsErrorState && (state.message == AuthErrorMessages.invalidAccessTokenError || state.message == AuthErrorMessages.invalidRefreshTokenError)) {
              context.pushNamedAndRemove(Routes.loginLanding);
            }
          },
        ),
      ],
      child: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        child: child,
      ),
    );
  }
}
