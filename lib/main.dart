import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled3/layout/home_layout.dart';
import 'package:untitled3/modules/on_boarding/on_boarding_screen.dart';
import 'package:untitled3/shared/bloc_observer.dart';
import 'package:untitled3/shared/cubit/cubit.dart';
import 'package:untitled3/shared/network/local/cache_helper.dart';
import 'package:untitled3/shared/network/remote/dio_helper.dart';

int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');

  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.isDark});

  final bool? isDark;
  static const Color iconColorDark = Colors.white;
  static const Color iconColorLight = Colors.black;
  static const Color textColor2 = Colors.black;
  static const Color textColor1 = Colors.white;
  static const Color appBarColor = Color.fromRGBO(36, 41, 46, 1);
  static const Color scaffoldBgcolor = Color.fromRGBO(36, 41, 46, 1);
  static const Color light = Colors.white;
  static const Color dark = Color.fromRGBO(36, 41, 46, 1);
  static const Color shadowColorLight = Color.fromRGBO(36, 41, 46, 1);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..createDatabase()
        ..getPrayer()
        ..changeAppMode(fromShared: isDark),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext, AppStates state) {
          return ScreenUtilInit(
              builder: (context, child) => MaterialApp(
                      debugShowCheckedModeBanner: false,
                      themeMode: AppCubit.get(context).isDark
                          ? ThemeMode.dark
                          : ThemeMode.light,
                      title: 'todoApp',
                      darkTheme: ThemeData(
                          iconTheme: const IconThemeData(color: iconColorDark),
                          drawerTheme: const DrawerThemeData(
                              backgroundColor: Colors.deepPurple),
                          appBarTheme: const AppBarTheme(
                            iconTheme: IconThemeData(color: iconColorDark),
                            systemOverlayStyle:
                                SystemUiOverlayStyle(statusBarColor: dark),
                            backgroundColor: dark,
                          ),
                          shadowColor: dark,
                          bottomNavigationBarTheme:
                              const BottomNavigationBarThemeData(
                            unselectedIconTheme:
                                IconThemeData(color: iconColorDark),
                            backgroundColor: dark,
                            type: BottomNavigationBarType.fixed,
                          ),
                          scaffoldBackgroundColor: scaffoldBgcolor,
                          fontFamily: 'Gilroy',
                          useMaterial3: true,
                          colorScheme: const ColorScheme.highContrastDark(
                            primary: Colors.deepPurple,
                            onPrimary: iconColorDark,
                            outline: Colors.grey,
                          ),
                          bottomSheetTheme: const BottomSheetThemeData(
                            backgroundColor: dark,
                          ),
                          primaryColor: Colors.deepPurple,
                          textTheme: const TextTheme(
                            titleLarge: TextStyle(
                                fontSize: 32,
                                fontFamily: "Gilroy-Thin.ttf",
                                color: textColor1),
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
                                color: textColor1),
                            displayMedium: TextStyle(
                                fontSize: 24,
                                fontFamily: "Gilroy-Medium.ttf",
                                color: textColor2),
                            displaySmall: TextStyle(
                                fontSize: 16,
                                fontFamily: "Gilroy-Medium.ttf",
                                color: textColor2),
                            labelMedium: TextStyle(
                                fontSize: 32,
                                fontFamily: "Gilroy-Medium.ttf",
                                color: textColor1,
                                fontWeight: FontWeight.w500),
                            bodyMedium: TextStyle(
                                fontSize: 24,
                                fontFamily: "Gilroy-Medium.ttf",
                                color: textColor1,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500),
                            labelLarge: TextStyle(
                                fontSize: 24,
                                fontFamily: "Gilroy-Medium.ttf",
                                color: Colors.deepPurple),
                            bodySmall: TextStyle(
                              fontSize: 15,
                              fontFamily: "Gilroy-Medium.ttf",
                              color: textColor1,
                            ),
                          ).apply(fontFamily: 'Gilroy')),
                      theme: ThemeData(
                          shadowColor: shadowColorLight,
                          primaryColorLight: light,
                          iconTheme: const IconThemeData(color: iconColorLight),
                          drawerTheme: const DrawerThemeData(
                              backgroundColor: Colors.deepPurple),
                          appBarTheme: const AppBarTheme(
                            systemOverlayStyle:
                                SystemUiOverlayStyle(statusBarColor: light),
                            backgroundColor: light,
                          ),
                          bottomNavigationBarTheme:
                              const BottomNavigationBarThemeData(
                            backgroundColor: light,
                            type: BottomNavigationBarType.fixed,
                          ),
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
                                color: Colors.black),
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
                              fontSize: 15,
                              fontFamily: "Gilroy-Medium.ttf",
                              color: Colors.white,
                            ),
                          ).apply(fontFamily: 'Gilroy')),
                      initialRoute:
                          initScreen == 0 || initScreen == null ? "first" : "/",
                      routes: {
                        '/': (context) =>
                            AnimatedSplashScreen.withScreenFunction(
                              splash: Lottie.asset(
                                  "assets/animations/loading.json"),
                              screenFunction: () async {
                                await Future.delayed(
                                    const Duration(seconds: 5));
                                return HomeLayout();
                              },
                              splashTransition:
                                  SplashTransition.rotationTransition,
                              pageTransitionType: PageTransitionType.fade,
                              animationDuration: const Duration(seconds: 2),
                            ),
                        "first": (context) => const OnBoardingScreen()
                      }));
        },
      ),
    );
  }
}
