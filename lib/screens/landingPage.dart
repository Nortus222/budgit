// ignore_for_file: file_names

import 'dart:async';
import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/addtransactionPage.dart';
import 'package:budgit/utilites/daysBetween.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/screens/historyPage.dart';
import 'package:budgit/screens/homePage.dart';
import 'package:provider/provider.dart';
import 'package:budgit/theme/themeData.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> tabs = [
    const HomePage(),
    const AddTransactionPage(),
    const HistoryPage(),
  ];

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      //TODO
      final model = Provider.of<AppStateModel>(context, listen: false);
      print("IsFirst: ${model.isFirst}");
      if (model.isFirst == true) {
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed('/intro');
      } else {
        if (daysBetween(DateTime.now(), model.appClosed ?? DateTime.now()) >
            0) {
          print("New Day (Landing)");
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed('/congrats');

        } else {
          print("Same Day");
          // Navigator.of(context, rootNavigator: true)
          //     .pushReplacementNamed('/congrats');
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
          BottomNavigationBarItem(icon: Icon(Icons.add)),
          BottomNavigationBarItem(icon: Icon(Icons.archive)),
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
