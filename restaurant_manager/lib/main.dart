import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/application/errors/AuthErrors.dart';
import 'package:restaurant_manager/application/services/auth/IAuthService.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_states.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/students/students_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';
import 'package:restaurant_manager/router/router.dart';
import 'package:restaurant_manager/router/routes.dart';
import 'dependency_container.dart' as dc;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await dc.setUp();
  await dc.getIt.get<IAuthService>().loadCachedAuthData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          lazy: true,
          create: (_) {
            AuthCubit authCubit = dc.getIt();

            return authCubit;
          },
        ),
        BlocProvider<MealsCubit>(
          lazy: true,
          create: (_) {
            MealsCubit mealsCubit = dc.getIt();

            return mealsCubit;
          },
        ),
        BlocProvider<StudentsCubit>(
          lazy: true,
          create: (_) {
            StudentsCubit studentsCubit = dc.getIt();

            return studentsCubit;
          },
        )
      ],
      child: ScreenUtilInit(
          designSize: const Size(428, 926),
          minTextAdapt: true,
          builder: (context, _) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: const MaterialApp(
                title: 'Restaurant Manager',
                debugShowCheckedModeBanner: false,
                onGenerateRoute: AppRouter.onGenerateRoute,
                initialRoute: Routes.root,
              ),
            );
          }),
    );
  }
}
