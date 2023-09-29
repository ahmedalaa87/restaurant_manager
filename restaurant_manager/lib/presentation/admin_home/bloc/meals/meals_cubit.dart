import 'package:bloc/bloc.dart';
import 'package:restaurant_manager/application/services/meals/IMealService.dart';
import 'package:restaurant_manager/domain/models/MealModel.dart';
import 'package:restaurant_manager/presentation/admin_home/bloc/meals/meals_states.dart';

import '../../../../domain/constatns/mealTypes.dart';

class MealsCubit extends Cubit<MealsState> {
  final IMealsService mealsService;
  int currentPage = 1;
  bool moreMeals = true;
  List<MealModel> meals = [];
  MealTypes? mealsType;

  MealsCubit({
    required this.mealsService,
  }) : super(MealsInitial());

  Future<void> getMeals() async {
    emit(GetAllMealsLoading());
    final response = await mealsService.getMeals(currentPage, mealsType);

    response.fold((failure) {
      emit(GetAllMealsError(failure.message));
    }, (meals) {
      this.meals.addAll(meals);
      currentPage += 1;
      if (meals.isEmpty) {
        moreMeals = false;
      }
      emit(GetAllMealsSuccess());
    });
  }

  Future<MealModel?> getMeal(int id) async {
    emit(GetMealByIdLoading());
    final response = await mealsService.getMeal(id);

    return response.fold((failure) {
      emit(GetMealByIdError(failure.message));
      return null;
    }, (meal) {
      emit(GetMealByIdSuccess(meal: meal));
      return meal;
    });
  }

  void createMeal(MealTypes mealType) {
    emit(CreateMealLoadingState());
    mealsService.createMeal(mealType).then((response) {
      response.fold(
        (failure) => emit(
          CreateMealErrorState(
            failure.message,
          ),
        ),
        (meal) {
          meals.insert(0, meal);
          emit(
            CreateMealSuccessState(meal: meal),
          );
        },
      );
    });
  }

  void addStudentToMeal(int studentId, int mealId) {
    emit(AddStudentToMealLoadingState());
    mealsService.addStudentToMeal(studentId, mealId).then((response) {
      response.fold(
        (failure) => emit(
          AddStudentToMealErrorState(
            failure.message,
          ),
        ),
        (student) {
          try {
            MealModel meal = meals.firstWhere((element) => element.id == mealId);
            meal.students.add(student);
            meal.studentCount += 1;
          } catch (_) {

          }
          emit(
            AddStudentToMealSuccessState(student: student),
          );
        },
      );
    });
  }

  void changeMealType(MealTypes? mealsType) async {
    this.mealsType = mealsType;
    clear();
    await getMeals();
  }

  bool canLoadMore() {
    return moreMeals;
  }

  void clear() {
    moreMeals = true;
    meals.clear();
    currentPage = 1;
  }
}
