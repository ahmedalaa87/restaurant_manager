import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

class DataOptionsListWidget extends StatefulWidget {
  final List<String> optionValues;
  final void Function(String?) onChanged;
  final String currentValue;
  final double width;
  final double height;

  const DataOptionsListWidget({
    Key? key,
    required this.optionValues,
    required this.onChanged,
    required this.currentValue,
    this.width = 150,
    this.height = 32,
  }) : super(key: key);

  @override
  State<DataOptionsListWidget> createState() => _DataOptionsListWidgetState();
}

class _DataOptionsListWidgetState extends State<DataOptionsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width.w,
      height: widget.height.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primaryContainer,
            context.colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: widget.currentValue,
          items: widget.optionValues
              .map(
                (value) => DropdownMenuItem(
                  value: value,
                  child: Text(
                    value,
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          icon: Icon(Icons.arrow_drop_down_sharp,
              color: context.colorScheme.onPrimary),
          style: context.theme.textTheme.titleMedium,
          dropdownDecoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, -5),
          dropdownMaxHeight: 250.h,
        ),
      ),
    );
  }
}
