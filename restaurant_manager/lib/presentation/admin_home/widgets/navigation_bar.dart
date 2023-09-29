import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_manager/infrastructure/auth/AuthInfo.dart';
import 'package:restaurant_manager/presentation/shared/extensions/context_extensions.dart';

import '../../../domain/constatns/userRoles.dart';

class AdminNavigationBar extends StatefulWidget {
  final void Function(int) onIndexChange;

  const AdminNavigationBar({Key? key, required this.onIndexChange}) : super(key: key);

  @override
  State<AdminNavigationBar> createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {
  int _currentIndex = 0;


  void _onIndexChange(int index) {
    if (index == _currentIndex) return;

    widget.onIndexChange(index);

    setState(() {
      _currentIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12)
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onIndexChange,
        backgroundColor: context.colorScheme.primary,
        selectedItemColor: context.colorScheme.onPrimary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.drumstickBite),
            label: "Meals",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.peopleGroup),
            label: "Students",
          ),
        ],
      ),
    );
  }
}
