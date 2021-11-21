import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_test_app/screen/home_screen.dart';
import 'package:weather_test_app/screen/login_page.dart';
import 'package:weather_test_app/screen/spalsh_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: SplashScreen(),
  //   );
  // }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(home: SplashScreen());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            onUnknownRoute: (settings) => CupertinoPageRoute(
                builder: (context) {
                  return SplashScreen();
                }
            ),
            onGenerateRoute: (settings) {
              if (settings.name == '\home_page') {
                return CupertinoPageRoute(
                  title: "MyPage",
                  settings: settings,
                  builder: (context) => HomeScreen(),
                );
              }
              if (settings.name == '\login_page') {
                return CupertinoPageRoute(
                  title: "MyPage",
                  settings: settings,
                  builder: (context) => SignInPage(),
                );
              }
            },
            title: 'Weather App',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            home:  SignInPage(),
          );
        }
      },
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}
