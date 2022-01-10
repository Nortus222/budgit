// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyBudget extends StatelessWidget {
  const DailyBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Consumer<AppStateModel>(
          builder: (BuildContext context, model, child) {
        return SizedBox(
            width: size.width - 40,
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  LocaleKeys.available_today.tr(),
                  style: Theme.of(context).textTheme.headline1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          LocaleKeys.personal.tr(),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          "\$${(model.dailyPersonal ?? "Null")}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width / 5,
                    ),
                    Column(
                      children: [
                        Text(
                          "Meal Plan",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          "\$${(model.dailyMealPlan ?? "Null")}",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ],
                ),
              ]),
            ));
      }),
    );
  }
}
