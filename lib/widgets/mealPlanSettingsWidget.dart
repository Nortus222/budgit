// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MealPlanSettingsWidget extends StatelessWidget {
  const MealPlanSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.decimalPattern("en_US");
    final heightMultiplier = SizeConfig.heightMultiplier!;

    return Material(
        color: Colors.transparent,
        child: Consumer<AppStateModel>(
            builder: (BuildContext context, model, child) {
          return Column(
            children: [
              Text(
                "Meal Plan",
                style: Theme.of(context).textTheme.headline1,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                        (model.mealPlan ?? -1) > 0
                            ? "\$${format.format(model.mealPlan ?? 0)}"
                            : "Spent",
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: (model.mealPlan ?? -1) > 0
                                ? Colors.black
                                : Colors.red)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: (2 * heightMultiplier),
                          bottom: 20,
                          left: 10,
                          right: 10),
                      child: CupertinoButton(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(27)),
                          padding: const EdgeInsets.all(10),
                          color: AppColors.blue,
                          child: Text(
                            "EDIT",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: AppColors.white),
                          ),
                          onPressed: () async {
                            return await showChangeDialog(
                                context, 'mealPlan', model);
                          }),
                    ),
                  )
                ],
              ),
              Text(
                "Due",
                style: Theme.of(context).textTheme.headline3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      DateFormat('yMMMd')
                          .format(model.mealPlanDue ?? DateTime.now()),
                      style: Theme.of(context).textTheme.headline3),
                  TextButton(
                    onPressed: () {
                      showDateTime(context, 'mealPlanDue', model);
                    },
                    child: const Icon(Icons.calendar_today_rounded),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black)),
                  )
                ],
              )
            ],
          );
        }));
  }
}
