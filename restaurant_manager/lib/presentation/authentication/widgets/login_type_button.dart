import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/presentation/authentication/pages/login_page.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';
import 'package:restaurant_manager/router/routes.dart';

class LoginTypeButton extends StatelessWidget {
  final LoginTypes type;
  const LoginTypeButton({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
      ),
      child: TextButton(
        onPressed: () => context.pushNamed(Routes.login, arguments: LoginScreenParams(loginType: type)),
        style: TextButton.styleFrom(
          backgroundColor: context.colorScheme.primary,
          textStyle: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          foregroundColor: context.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 30.w,
            vertical: 20.h,
          ),
        ),
        child: Text(type.name.toUpperCase()),
      ),
    );
  }
}
