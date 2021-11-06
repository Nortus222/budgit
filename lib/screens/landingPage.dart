// ignore_for_file: file_names

import 'package:budgit/screens/dbScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/screens/historyPage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<Widget> tabs = [HomeTab(), HistoryPage(), DBscreen()];

  @override
  Widget build(BuildContext context) {
    print("History: BUILD\n");
    return CupertinoTabView(builder: (BuildContext context) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.archive)),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize))
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return tabs[index];
        },
      );
    });
  }
}

// Home Tab
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
          child: Container(
              child: Material(
                  child: Text(
        'Home Tab',
        style: TextStyle(fontSize: 36),
      )))),
    );
  }
}
