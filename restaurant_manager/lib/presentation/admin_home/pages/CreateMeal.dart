import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/domain/constatns/mealTypes.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_states.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../shared/utils/validators.dart';
import '../../shared/widgets/DataField.dart';
import '../../shared/widgets/custom_button.dart';
import '../widgets/data_option_list.dart';

class CreateMeal extends StatefulWidget {
  const CreateMeal({Key? key}) : super(key: key);

  @override
  State<CreateMeal> createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  MealTypes mealType = MealTypes.breakfast;

  void createNewMeal(BuildContext context) {
    MealsCubit itemsCubit = context.read<MealsCubit>();
    itemsCubit.createMeal(mealType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealsCubit, MealsState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is CreateMealErrorState) {
          context.showSnackBar(state.message, Colors.red);
        }

        if (state is CreateMealSuccessState) {
          context.showSnackBar("Meal Created Successfully", context.colorScheme.primary);
          context.navigator.pop(state.meal.id);
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.2,
          maxChildSize: 1,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.h),
                      child: Text(
                        "Create new meal",
                        style: context.theme.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    DataOptionsListWidget(
                      width: 0.7.sw,
                      height: 50.h,
                      optionValues: MealTypes.values.map((e) => e.name).toList(),
                      currentValue: mealType.name,
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          mealType = MealTypes.values.firstWhere((element) => element.name == value);
                        });
                      },
                    ),
                    SizedBox(height: 30.h,),
                    CustomButton(
                      callback: () => createNewMeal(context),
                      text: "Create",
                      isLoading: state is CreateMealLoadingState,
                    ),
                    SizedBox(height: 10.h,)
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
