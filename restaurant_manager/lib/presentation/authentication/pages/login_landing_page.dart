import 'package:flutter/material.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../widgets/login_type_button.dart';

class LoginLandingPage extends StatelessWidget {
  const LoginLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Manager'),
        backgroundColor: context.colorScheme.primary,
        titleTextStyle: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login as a",
              style: context.textTheme.headlineMedium,
            ),
            const LoginTypeButton(
              type: LoginTypes.student,
            ),
            const LoginTypeButton(
              type: LoginTypes.admin,
            ),
          ],
        ),
      ),
    );
  }
}
