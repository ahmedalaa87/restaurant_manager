import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/core/extensions.dart';
import 'package:restaurant_manager/domain/models/MealModel.dart';
import 'package:restaurant_manager/presentation/admin_home/pages/StudentPage.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';
import 'package:restaurant_manager/router/routes.dart';
import '../../../domain/models/StudentModel.dart';
import '../../admin_home/pages/MealPage.dart';
import 'PropertyHolder.dart';

class DataCard extends StatefulWidget {
  final String title;
  final Map<String, String> data;
  final VoidCallback? onTap;

  const DataCard({
    Key? key,
    required this.title,
    this.onTap,
    required this.data,
  }) : super(key: key);

  factory DataCard.fromMeal(MealModel meal, BuildContext context) {
    return DataCard(
      title: "Meal #${meal.id}",
      onTap: () {
        context.pushNamed(Routes.meal,
            arguments: MealPageArgs(mealId: meal.id));
      },
      data: {
        "Type": meal.mealType.name,
        "Date": meal.date.dateFormat,
        "Student count": meal.studentCount.toString(),
      },
    );
  }

  factory DataCard.fromStudent(StudentModel student, BuildContext context) {
    return DataCard(
      onTap: () {
        context.pushNamed(
          Routes.student,
          arguments: StudentPageArgs(
            student: student,
          ),
        );
      },
      title: "Student #${student.id}",
      data: {
        "Name": student.name,
        "Grade": student.gradeYear.toString(),
      },
    );
  }

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  bool isHovered = false;

  List<PropertyHolder> get propertyHolders {
    List<PropertyHolder> holders = [];
    widget.data.forEach((key, value) {
      holders.add(
        PropertyHolder(
          propertyName: key,
          data: value,
        ),
      );
    });

    return holders;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          if (isHovered) return;

          setState(() {
            isHovered = true;
          });
        },
        onExit: (_) {
          if (!isHovered) return;

          setState(() {
            isHovered = false;
          });
        },
        child: Card(
          margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
          color: isHovered ? Colors.grey[900] : null,
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: context.theme.textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 25,
                ),
                Wrap(
                  spacing: 20.w,
                  runSpacing: 10.h,
                  children: propertyHolders,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
