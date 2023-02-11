import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/layout/home_layout.dart';
import 'package:untitled3/modules/on_boarding/on_boarding_screen.dart';
import 'package:untitled3/shared/bloc_observer.dart';

int? initScreen;

Future<void> main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (context, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'todoApp',
                theme: ThemeData(
                    fontFamily: 'Gilroy',
                    useMaterial3: true,
                    colorScheme: const ColorScheme.light()
                        .copyWith(primary: Colors.deepPurple),
                    primaryColor: Colors.deepPurple,
                    textTheme: const TextTheme(
                      titleLarge: TextStyle(
                          fontSize: 32,
                          fontFamily: "Gilroy-Thin.ttf",
                          color: Colors.black),
                      titleMedium: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.deepPurple),
                      titleSmall: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.redAccent),
                      bodyLarge: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy-Regular.ttf",
                          color: Colors.black54),
                      displayMedium: TextStyle(
                          fontSize: 24,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.white),
                      displaySmall: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.white),
                      labelMedium: TextStyle(
                          fontSize: 32,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      bodyMedium: TextStyle(
                          fontSize: 24,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500),
                      labelLarge: TextStyle(
                          fontSize: 24,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.deepPurple),
                      bodySmall: TextStyle(
                          fontSize: 16,
                          fontFamily: "Gilroy-Medium.ttf",
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ).apply(fontFamily: 'Gilroy')),
                initialRoute:
                    initScreen == 0 || initScreen == null ? "first" : "/",
                routes: {
                  '/': (context) => AnimatedSplashScreen.withScreenFunction(
                        splash: Lottie.asset("assets/animations/loading.json"),
                        screenFunction: () async {
                          return HomeLayout();
                        },
                        splashTransition: SplashTransition.rotationTransition,
                        pageTransitionType: PageTransitionType.fade,
                        animationDuration: const Duration(seconds: 2),
                      ),
                  "first": (context) => OnBoardingScreen()
                }));
  }
}
