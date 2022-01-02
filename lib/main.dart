import 'package:budgit/db/model/transaction.dart';
import 'package:budgit/model/appSystemManager.dart';
import 'package:budgit/screens/congratulationsPage.dart';
import 'package:budgit/screens/introPage.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:flutter/material.dart';
import 'package:budgit/screens/landingPage.dart';
import 'package:provider/provider.dart';
import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppStateModel>(
        create: (_) => AppStateModel()..init(),
      ),
      FutureProvider(create: (_) {}, initialData: const [])
    ],
    child: const MyApp(),
  ));

  // runApp(ChangeNotifierProvider<AppStateModel>(
  //     create: (_) => AppStateModel()..init(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig().init(constraints);
      return MaterialApp(
        locale: const Locale("en", "US"),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        routes: {
          '/settings': (BuildContext context) => const SettingsPage(),
          '/home': (BuildContext context) => const LandingPage(),
          '/intro': (BuildContext context) => const IntroPage(),
          '/congrats': (BuildContext context) => const CongratulationsPage(),
        },
        theme: window.physicalSize.height > 1400
            ? BudgitTheme()
            : BudgitThemeSmall(),
        home: const AppSytemManager(LandingPage()),
      );
    });
  }
}
