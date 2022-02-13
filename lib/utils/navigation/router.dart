import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/constants/routes.dart';
import 'package:raed_store/homeScreen.dart';
import 'package:raed_store/login_page.dart';
import 'package:raed_store/register_page.dart';
import 'package:raed_store/tab_bar_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  log("Route Name:" + settings.name.toString());
  log("Route arg:" + settings.arguments.toString());

  switch (settings.name) {
    case RoutesNames.loginRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    case RoutesNames.tabBarMainView:
      return MaterialPageRoute(
        builder: (context) => const TabBarMainView(),
      );
    case RoutesNames.registerRoute:
      return MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      );

    case RoutesNames.homeRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
  }
}
