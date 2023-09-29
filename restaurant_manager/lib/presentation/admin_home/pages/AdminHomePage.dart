import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_manager/domain/constatns/userRoles.dart';

import '../../../infrastructure/auth/AuthInfo.dart';
import '../widgets/navigation_bar.dart';
import 'MealsPage.dart';
import 'StudentsPage.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentPageIndex = 0;

  void _changePageIndex(int index) {
    if (index == 1 &&
        AuthInfo.user?.role != UserRoles.teacher &&
        AuthInfo.user?.role != UserRoles.manager) return;
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AdminNavigationBar(
        onIndexChange: _changePageIndex,
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: const [
          MealsPage(),
          StudentsPage(),
        ],
      ),
    );
  }
}
