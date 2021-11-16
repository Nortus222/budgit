// ignore_for_file: file_names

import 'package:budgit/theme/themeData.dart';

import 'package:budgit/widgets/barChartWidget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/widgets/dailyBudgetWidget.dart';
import 'package:budgit/widgets/remainingBudgetWidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          color: AppColors.white,
          height: 140,
        ),
        Positioned(
          top: 140,
          child: ClipRRect(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(60), right: Radius.circular(60)),
            child: Container(
              width: size.width,
              height: size.height / 2,
              color: AppColors.green,
            ),
          ),
        ),
        Positioned(
          top: 140 * 2 + 50,
          child: ClipRRect(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(60), right: Radius.circular(60)),
            child: Container(
              width: size.width,
              height: size.height / 2 + 100,
              color: AppColors.orange,
            ),
          ),
        ),
        Center(
            child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            DailyBudget(),
            SizedBox(
              height: 30,
            ),

            RemainingBudget(),
            SizedBox(
              height: 50,
            ),
            BarChartWidget()

          ],
        )),
      ],
    );
  }
}
