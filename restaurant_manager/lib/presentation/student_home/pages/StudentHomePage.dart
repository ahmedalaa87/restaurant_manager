import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager/infrastructure/auth/AuthInfo.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../../router/routes.dart';
import '../widgets/IdQrCodeImage.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (oldState, currentState) => oldState != currentState,
        buildWhen: (oldState, currentState) => oldState != currentState,
        listener: (context, state) {
          if (state is AuthErrorState) {
            context.showSnackBar(state.message, Colors.red);
          }
        },
        builder: (context, state) {
          AuthCubit authCubit = context.read<AuthCubit>();
          return Scaffold(
              appBar: AppBar(
                title: const Text('Restaurant Manager'),
                backgroundColor: context.colorScheme.primary,
                titleTextStyle: context.textTheme.titleLarge?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.pushNamed(Routes.changePassword);
                    },
                    icon: Icon(Icons.key, color: context.colorScheme.onPrimary,),
                  ),
                  IconButton(
                      onPressed: state is AuthLoadingState ? null :  authCubit.logout,
                      icon: Icon(Icons.logout, color: context.colorScheme.onPrimary,),
                  )
                ],
              ),
              body: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Welcome, ${AuthInfo.user?.name}!",
                      style: context.textTheme.headlineMedium,
                    ),
                    IdQrCodeImage(id: AuthInfo.user?.id ?? 0,),
                  ],
                ),
              )
          );
        }
    );

  }
}
