import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
              ),
              child: TextButton(
                  onPressed: () {},
                  child: Text("Student"),
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
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text("Student"),
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
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.h,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text("Student"),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
