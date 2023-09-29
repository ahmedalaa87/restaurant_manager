import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_states.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../../router/routes.dart';
import '../../shared/utils/validators.dart';
import '../../shared/widgets/custom_button.dart';
import '../widgets/credintials_field.dart';

class LoginScreenParams {
  final LoginTypes loginType;

  LoginScreenParams({required this.loginType});
}

class LoginPage extends StatefulWidget {
  final LoginTypes loginType;
  const LoginPage({Key? key, required this.loginType}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(debugLabel: "login");
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      AuthCubit authCubit = context.read<AuthCubit>();
      authCubit.login(_emailController.text, _passwordController.text, widget.loginType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (oldState, currentState) {
        return oldState != currentState;
      },
      listenWhen: (oldState, currentState) {
        return oldState != currentState;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Restaurant Manager",
                style: context.theme.textTheme.headlineMedium
                    ?.copyWith(color: context.colorScheme.onPrimary)),
            backgroundColor: context.colorScheme.primary,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 220.h,
                  ),
                  Text(
                    "Login as a ${widget.loginType.name}",
                    style: context.theme.textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  CredentialsField(
                    keyboardType: TextInputType.emailAddress,
                    labelText: "Email Address",
                    controller: _emailController,
                    hintText: "Enter your email address",
                    prefixIcon: const Icon(Icons.email),
                    isPassword: false,
                    validator: validateNotEmpty,
                  ),
                  CredentialsField.password(
                    labelText: "Password",
                    controller: _passwordController,
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.key),
                    validator: validateNotEmpty,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomButton(
                    callback: () => login(context),
                    text: "Login",
                    isLoading: state is AuthLoginLoadingState || state is AuthGetUserLoadingState,
                  )
                ],
              ),
            ),
          ),
        );
      },
      listener: (_, state) {
        if (state is AuthErrorState) {
          context.showSnackBar(state.message, Colors.red);
        }

        if (state is AuthLoginSuccessState) {
          context.showSnackBar("Logged in successfully", context.theme.colorScheme.primary);
          AuthCubit authCubit = context.read<AuthCubit>();
          authCubit.getCurrentUser();
          // get all cubits to initialize them
        }

        if (state is AuthGetUserSuccessState) {
          context.pushNamedAndRemove(Routes.home);
        }
      },
    );
  }
}
