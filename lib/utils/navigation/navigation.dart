import 'package:flutter/cupertino.dart';

class Navigation {
  static Navigation? singleton;
  static dynamic navigation_Key;
  factory Navigation({required GlobalKey navigationKey}) {
    navigation_Key = navigationKey;
    singleton = singleton ?? Navigation._internal();
    return singleton!;
  }

  Navigation._internal();

  Future<dynamic> navigateTo({required String routeName,Object? arg}) {
    return navigation_Key.currentState!.pushNamed(routeName,arguments:arg);
  }

  Future<dynamic> navigateAndReplacement({required String routeName,Object? arg}) {
    return navigation_Key.currentState!.pushReplacementNamed(routeName,arguments:arg);
  }

  navigateAndPopUntil({required bool beCleared}) {
    return navigation_Key.currentState!.popUntil((_) => beCleared);
  }

  Future<dynamic> navigateAndRemoveUntil(
      {required String routeName, bool beCleared: false,Object? arg}) {
    return navigation_Key.currentState!
        .pushNamedAndRemoveUntil(routeName, (_) => beCleared,arguments:arg);
  }

  goBack({dynamic argument}) {
    return navigation_Key.currentState!.pop(argument);
  }
}
