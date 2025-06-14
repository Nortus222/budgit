// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class MealPlanSettingsWidget extends StatelessWidget {
  const MealPlanSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var format = NumberFormat.decimalPattern(context.locale.languageCode);
    final heightMultiplier = SizeConfig.heightMultiplier!;

    return Material(
        color: Colors.transparent,
        child: Consumer<AppStateModel>(
            builder: (BuildContext context, model, child) {
          return Column(
            children: [
              Text(
                "Meal Plan",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                        (model.mealPlan ?? -1) > 0
                            ? "\$${format.format(model.mealPlan ?? 0)}"
                            : LocaleKeys.spent.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
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
                            LocaleKeys.edit.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
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
                LocaleKeys.due.tr(),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      DateFormat('yMMMd')
                          .format(model.mealPlanDue ?? DateTime.now()),
                      style: Theme.of(context).textTheme.displaySmall),
                  TextButton(
                    onPressed: () {
                      // showDateTime(context, 'mealPlanDue', model);
                    },
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.black)),
                    child: const Icon(Icons.calendar_today_rounded),
                  )
                ],
              )
            ],
          );
        }));
  }
}
