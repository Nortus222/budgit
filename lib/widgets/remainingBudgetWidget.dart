// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemainingBudget extends StatelessWidget {
  const RemainingBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    int daysBetween(DateTime day1, DateTime day2) {
      day1 = DateTime(day1.year, day1.month, day1.day);
      day2 = DateTime(day2.year, day2.month, day2.day);

      return (day1.difference(day2).inDays);
    }

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
                        "\$${(model.personal ?? "Null")}",
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
                        "\$${(model.mealPlan ?? "Null")}",
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
