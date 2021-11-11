// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgit/utilites/daysBetween.dart';

class RemainingBudget extends StatelessWidget {
  RemainingBudget({Key? key}) : super(key: key);

  var format = NumberFormat.decimalPattern("en_US");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
        color: Colors.transparent,
        child: Consumer<AppStateModel>(
            builder: (BuildContext context, model, chid) {
          return Column(
            children: [
              Text(
                "Remaining Budget",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: AppColors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Personal",
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: AppColors.white),
                      ),
                      Text(
                        "\$${format.format(model.personal ?? 0)}",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: AppColors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${daysBetween((model.personalDue ?? DateTime.now()), DateTime.now())} days left",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width / 6,
                  ),
                  Column(
                    children: [
                      Text(
                        "Meal Plan",
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: AppColors.white),
                      ),
                      Text(
                        "\$${format.format(model.mealPlan ?? 0)}",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: AppColors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${daysBetween((model.mealPlanDue ?? DateTime.now()), DateTime.now())} days left",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }));
  }
}
