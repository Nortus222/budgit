// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgit/utilites/daysBetween.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class RemainingBudget extends StatelessWidget {
  const RemainingBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.decimalPattern(context.locale.languageCode);
    var size = MediaQuery.of(context).size;

    return Material(
        color: Colors.transparent,
        child: Consumer<AppStateModel>(
            builder: (BuildContext context, model, chid) {
          return Column(
            children: [
              Text(
                LocaleKeys.remaining_budget.tr(),
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
                        LocaleKeys.personal.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(color: AppColors.white),
                      ),
                      Text(
                        (model.personal ?? -1) > 0
                            ? "\$${format.format(model.personal ?? 0)}"
                            : LocaleKeys.spent.tr(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: (model.personal ?? -1) > 0
                                ? AppColors.white
                                : Colors.red),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        daysBetween((model.personalDue ?? DateTime.now()),
                                    DateTime.now()) <
                                0
                            ? LocaleKeys.expired.tr()
                            : "${daysBetween((model.personalDue ?? DateTime.now()), DateTime.now())} days left", //TODO
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: daysBetween(
                                        (model.personalDue ?? DateTime.now()),
                                        DateTime.now()) <
                                    0
                                ? Colors.red
                                : AppColors.white),
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
                        (model.mealPlan ?? -1) > 0
                            ? "\$${format.format(model.mealPlan ?? 0)}"
                            : LocaleKeys.spent.tr(),
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: (model.mealPlan ?? -1) > 0
                                ? AppColors.white
                                : Colors.red),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        daysBetween((model.mealPlanDue ?? DateTime.now()),
                                    DateTime.now()) <
                                0
                            ? LocaleKeys.expired.tr()
                            : "${daysBetween((model.mealPlanDue ?? DateTime.now()), DateTime.now())} days left", //TODO
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: daysBetween(
                                        (model.mealPlanDue ?? DateTime.now()),
                                        DateTime.now()) <
                                    0
                                ? Colors.red
                                : AppColors.white),
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
