// ignore_for_file: file_names

import 'dart:async';

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/dbScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/screens/historyPage.dart';
import 'package:budgit/screens/homePage.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:provider/provider.dart';
import 'package:budgit/theme/themeData.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> tabs = [HomePage(), HistoryPage(), DBscreen()];

  int daysBetween(DateTime day1, DateTime day2) {
    day1 = DateTime(day1.year, day1.month, day1.day);
    day2 = DateTime(day2.year, day2.month, day2.day);

    return (day1.difference(day2).inDays);
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      final model = Provider.of<AppStateModel>(context, listen: false);
      print("IsFirst: ${model.isFirst}");
      if (model.isFirst == true) {
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed('/intro');
      } else {
        if (daysBetween(DateTime.now(), model.appClosed ?? DateTime.now()) >=
            1) {
          print("New, Day");
        } else {
          print("Same Day");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.archive)),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize))
        ],
        backgroundColor: AppColors.beige,
        activeColor: AppColors.blue,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
            onGenerateRoute: (settings) {},
            builder: (BuildContext context) {
              return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    border: const Border(),
                    transitionBetweenRoutes: false,
                    backgroundColor: Colors.white,
                    trailing: TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed('/settings');
                        },
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color?>(Colors.grey)),
                        child: const Icon(Icons.segment_rounded)),
                  ),
                  child: tabs[index]);
            });
      },
    );
  }
}
