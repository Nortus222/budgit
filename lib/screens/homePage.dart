// ignore_for_file: file_names

import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';

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
    final heightMultiplier = SizeConfig.heightMultiplier!;

    return Stack(
      children: [
        Container(
          color: AppColors.white,
          height: 16.5 * heightMultiplier,
        ),
        Positioned(
          top: 16.5 * heightMultiplier,
          child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(60), right: Radius.circular(60)),
            child: Container(
              width: size.width,
              height: size.height / 2,
              color: AppColors.green,
            ),
          ),
        ),
        Positioned(
          top: 37 * heightMultiplier,
          child: ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(60), right: Radius.circular(60)),
            child: Container(
              width: size.width,
              height: size.height / 1.5,
              color: AppColors.orange,
            ),
          ),
        ),
        Center(
            child: Column(
          children: [
            SizedBox(
              height: 1.5 * heightMultiplier,
            ),
            const DailyBudget(),
            SizedBox(
              height: 3 * heightMultiplier,
            ),
            RemainingBudget(),
            SizedBox(
              height: 6 * heightMultiplier,
            ),
            const BarChartWidget()
          ],
        )),
      ],
    );
  }
}
