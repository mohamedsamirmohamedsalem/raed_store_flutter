import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raed_store/utils/navigation/navigation.dart';


import 'constants/images.dart';
import 'constants/routes.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final _splashDelay = 2;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: _splashDelay);
    return Timer(_duration, _navigationPage);
  }

  void _navigationPage() async {
    Navigation(navigationKey: navigatorKey).navigateAndReplacement(routeName: RoutesNames.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: Image(image: AssetImage('assets/images/raad_store_splash.jpeg'),width: 200,height: 200,)),
    );
  }
}
