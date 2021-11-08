// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/widgets/dailyBudgetWidget.dart';
import 'package:budgit/widgets/remainingBudgetWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
          child: Column(
        children: [
          DailyBudget(),
          SizedBox(
            height: 30,
          ),
          RemainingBudget()
        ],
      )),
    );
  }
}
