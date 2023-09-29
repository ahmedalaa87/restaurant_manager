import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme {
    return Theme.of(this);
  }

  ColorScheme get colorScheme {
    return theme.colorScheme;
  }

  TextTheme get textTheme {
    return theme.textTheme;
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
                color: Colors.white
            ),
          ),
          backgroundColor: color,
        )
    );
  }

  void pushNamedAndRemove(String routeName, {Object? arguments}) {
    navigator.pushNamedAndRemoveUntil(routeName, (_) => false, arguments: arguments);
  }

  void pushNamed(String routeName, {Object? arguments}) {
    navigator.pushNamed(routeName, arguments: arguments);
  }
}