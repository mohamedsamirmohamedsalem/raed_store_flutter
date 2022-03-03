import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:raed_store/splash_screen.dart';
import 'utils/navigation/router.dart' as router;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/translations',
      startLocale: const Locale('ar', 'EG') ,
      // <-- change the path of the translation files
      fallbackLocale: const Locale('ar', 'EG'),
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
        locale: const  Locale('ar', 'EG'),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Raed Store",
      home: SplashScreen(),
      onGenerateRoute: router.generateRoute,
    );
  }
}
