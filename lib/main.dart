import 'package:flutter/material.dart';
import 'package:raed_store/splash_screen.dart';
import 'utils/navigation/router.dart' as router;

final GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Raed Store",
      home: SplashScreen(),
      onGenerateRoute: router.generateRoute,
    );
  }
}

