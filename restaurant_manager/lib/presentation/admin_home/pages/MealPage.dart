import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/core/extensions.dart';
import 'package:restaurant_manager/domain/models/MealModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';
import 'package:restaurant_manager/presentation/shared/widgets/DataCard.dart';

import '../../../router/routes.dart';
import '../../shared/widgets/PropertyHolder.dart';
import '../../shared/widgets/loading_indicator.dart';
import 'QrReaderPage.dart';

class MealPageArgs {
  final int mealId;

  MealPageArgs({required this.mealId});
}

class MealPage extends StatelessWidget {
  final int mealId;
  const MealPage({Key? key, required this.mealId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MealModel? meal;
    MealsCubit mealsCubit = context.read<MealsCubit>();
    mealsCubit.getMeal(mealId);
    return BlocConsumer<MealsCubit, MealsState>(
      listenWhen: (oldState, newState) => oldState != newState,
      buildWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is MealsError) {
          context.showSnackBar(state.message, Colors.red);
        }

        if (state is GetMealByIdSuccess) {
          meal = state.meal;
        }

        if (state is AddStudentToMealSuccessState) {
          meal?.students.add(state.student);
          context.showSnackBar("Student Added Successfully", Colors.green);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: context.colorScheme.onPrimary,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final code = await context.navigator.pushNamed(Routes.qrCodeReader);
                  if (code == null) return;
                  try {
                    Map<String, dynamic> data = jsonDecode(code as String);

                    if (data["timestamp"] != null && data["timestamp"] < DateTime.now().toUtc().timeStamp - 350) {
                      if (context.mounted) {
                      context.showSnackBar("QR Code Expired", Colors.red);
                      }
                      return;
                    }

                    mealsCubit.addStudentToMeal(data["id"], mealId, data["timestamp"] != null);
                  } catch (e) {
                    if (context.mounted) {
                      context.showSnackBar("Invalid QR Code", Colors.red);
                    }
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ],
            centerTitle: true,
            backgroundColor: context.colorScheme.primary,
            title: Text(
              "Meal #$mealId",
            ),
            titleTextStyle: context.theme.textTheme.headlineMedium
                ?.copyWith(color: context.colorScheme.onPrimary),
          ),
          body: state is GetMealByIdLoading
              ? const Center(
                  child: LoadingIndicator(),
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  child: ListView(
                    children: meal != null
                        ? [
                            PropertyHolder(
                              propertyName: "Type",
                              data: meal!.mealType.name,
                              isTitle: true,
                            ),
                            PropertyHolder(
                              propertyName: "Date",
                              data: meal!.date.dateFormat,
                              isTitle: true,
                            ),
                            PropertyHolder(
                              propertyName: "Student count",
                              data: meal!.studentCount.toString(),
                              isTitle: true,
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            ...meal!.students
                                .map((student) =>
                                    DataCard.fromStudent(student, context))
                                .toList(),
                          ]
                        : [],
                  ),
                ),
        );
      },
    );
  }
}
