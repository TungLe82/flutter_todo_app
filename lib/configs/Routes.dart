import 'package:flutter/material.dart';
import 'package:my_app/screens/addTodo.dart';
import 'package:my_app/screens/login.dart';
import 'package:my_app/screens/register.dart';
import 'package:my_app/screens/todo.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case '/todo':
        return MaterialPageRoute(builder: (_) => TodoPage());
      case '/addTodo':
        return MaterialPageRoute(builder: (_) => AddTodo());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
