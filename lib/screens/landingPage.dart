// ignore_for_file: file_names

import 'package:budgit/screens/dbScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/screens/historyPage.dart';
import 'package:budgit/screens/homePage.dart';
import 'package:budgit/screens/settingsPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> tabs = [HomePage(), HistoryPage(), DBscreen()];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.archive)),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize))
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
            onGenerateRoute: (settings) {},
            builder: (BuildContext context) {
              return CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    //backgroundColor: Colors.white,
                    border: Border(),
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
