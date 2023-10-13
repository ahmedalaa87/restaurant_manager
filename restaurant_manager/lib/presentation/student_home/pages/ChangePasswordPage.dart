import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../shared/utils/validators.dart';
import '../../shared/widgets/credintials_field.dart';
import '../../shared/widgets/custom_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: "login");
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void changePassword(BuildContext context) {
    AuthCubit authCubit = context.read();

    if (!_formKey.currentState!.validate()) return;

    authCubit.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (oldState, newState) => oldState != newState,
      buildWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is ChangePasswordErrorState) {
          context.showSnackBar(state.message, Colors.red);
        }

        if (state is ChangePasswordSuccessState) {
          context.showSnackBar("Password changed successfully", Colors.green);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Restaurant Manager'),
            backgroundColor: context.colorScheme.primary,
            titleTextStyle: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CredentialsField.password(
                  labelText: "Current password",
                  controller: _currentPasswordController,
                  hintText: "Enter your current password",
                  prefixIcon: const Icon(Icons.key),
                  validator: validateNotEmpty,
                ),
                CredentialsField.password(
                  labelText: "New password",
                  controller: _newPasswordController,
                  hintText: "Enter your new password",
                  prefixIcon: const Icon(Icons.key),
                  validator: validateNotEmpty,
                ),
                SizedBox(
                  height: 15.h,
                ),
                CustomButton(
                  callback: () => changePassword(context),
                  text: "Change password",
                  isLoading: state is ChangePasswordLoadingState,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
