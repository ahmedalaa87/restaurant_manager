import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/domain/models/MealModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_cubit.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_states.dart';
import 'package:restaurant_manager/presentation/admin_home/pages/CreateMeal.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_cubit.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../../domain/constatns/mealTypes.dart';
import '../../../router/routes.dart';
import '../../shared/widgets/CreateNewButton.dart';
import '../../shared/widgets/DataCard.dart';
import '../../shared/widgets/loading_indicator.dart';
import '../widgets/data_option_list.dart';
import 'MealPage.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({Key? key}) : super(key: key);

  Future<void> refresh(BuildContext context) async {
    MealsCubit mealsCubit = context.read<MealsCubit>();
    mealsCubit.clear();
    mealsCubit.getMeals();
  }

  @override
  Widget build(BuildContext context) {
    MealsCubit mealsCubit =
    context.read<MealsCubit>();
    mealsCubit.getMeals();
    return BlocConsumer<MealsCubit, MealsState>(
      buildWhen: (oldState, newState) => oldState != newState,
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state is MealsError) {
          context.showSnackBar(state.message, Colors.red);
        }
      },
      builder: (context, state) {
        List<MealModel> meals = mealsCubit.meals;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Meals"),
            actions: [
              IconButton(onPressed: () {
                context.read<AuthCubit>().logout();
              }, icon: Icon(Icons.logout, color: context.colorScheme.onPrimary,)),
              DataOptionsListWidget(
                optionValues: MealTypes.values.map((e) => e.name).toList()..insert(0, "All"),
                currentValue: mealsCubit.mealsType?.name ?? "All",
                onChanged: (String? value) {
                  if (value == null) return;
                  if (value == "All") {
                    mealsCubit.changeMealType(null);
                    return;
                  }
                  mealsCubit.changeMealType(MealTypes.values.firstWhere((element) => element.name == value));
                },
              ),
            ],
            backgroundColor: context.colorScheme.primary,
            titleTextStyle: context.theme.textTheme.headlineMedium
                ?.copyWith(color: context.colorScheme.onPrimary),
          ),
            floatingActionButton: CreateNewButton(
              onResultCallBack: (mealId) {
                context.pushNamed(Routes.meal, arguments: MealPageArgs(mealId: mealId));
              },
              toShowScreen: const CreateMeal(),
              heroTag: "meals",
            ),
          body: state is GetAllMealsLoading &&
              mealsCubit.meals.isEmpty
              ? const Center(child: LoadingIndicator())
              : RefreshIndicator(
            onRefresh: () async {
              await refresh(context);
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (_, index) {
                bool isLastWidget = index == meals.length - 1;

                if (isLastWidget &&
                    mealsCubit.canLoadMore() &&
                    state is GetAllMealsSuccess) {
                   mealsCubit.getMeals();
                }


                Widget transactionWidget = DataCard.fromMeal(
                  meals[index],
                  context
                );

                if (state is GetAllMealsLoading &&
                    isLastWidget) {
                  return Column(
                    children: [
                      transactionWidget,
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: LoadingIndicator(),
                      )
                    ],
                  );
                }
                return transactionWidget;
              },
              itemCount: meals.length,
            ),
          ),
          );
      },
    );
  }
}
