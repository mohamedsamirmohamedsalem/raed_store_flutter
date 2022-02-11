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
  final _splashDelay = 4;

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
    //await UserSingleton().getStoredUser();
    Navigation(navigationKey: navigatorKey).navigateAndReplacement(routeName: RoutesNames.loginRoute);


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(child: Image(image: AssetImage(AppImages.SPLASH))),
    );
  }
}
