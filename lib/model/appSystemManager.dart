// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSytemManager extends StatefulWidget {
  final Widget child;
  const AppSytemManager(this.child, {Key? key}) : super(key: key);

  @override
  _AppSytemManagerState createState() => _AppSytemManagerState();
}

class _AppSytemManagerState extends State<AppSytemManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  int daysBetween(DateTime day1, DateTime day2) {
    day1 = DateTime(day1.year, day1.month, day1.day);
    day2 = DateTime(day2.year, day2.month, day2.day);

    return (day1.difference(day2).inDays);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final model = Provider.of<AppStateModel>(context, listen: false);

    switch (state) {
      case AppLifecycleState.paused:
        model.setAppClosed('appClosed', DateTime.now());
        print('paused: ${DateTime.now()}');
        break;
      case AppLifecycleState.detached:
        model.setAppClosed('appClosed', DateTime.now());
        print('detached: ${DateTime.now()}');
        break;
      case AppLifecycleState.resumed: //TODO
        print("Resumed");
        if (daysBetween(DateTime.now(), model.appClosed ?? DateTime.now()) >=
            1) {
          print("New, Day");
        } else {
          print("Same Day");
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
