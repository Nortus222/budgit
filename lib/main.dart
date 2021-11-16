import 'package:budgit/model/appSystemManager.dart';
import 'package:budgit/screens/introPage.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:flutter/material.dart';
import 'package:budgit/screens/landingPage.dart';
import 'package:provider/provider.dart';
import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(ChangeNotifierProvider<AppStateModel>(
      create: (_) => AppStateModel()..init(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppSytemManager(
      MaterialApp(

        locale: const Locale("en", "US"),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],

        debugShowCheckedModeBanner: false,
        routes: {
          '/settings': (BuildContext context) => const SettingsPage(),
          '/home': (BuildContext context) => const LandingPage(),
          '/intro': (BuildContext context) => const IntroPage(),
        },
        theme: BudgitTheme(),
        home: const LandingPage(),
      ),
    );
  }
}
