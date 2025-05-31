// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
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
                  "Available Today",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Personal",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "\$${(model.dailyPersonal ?? "Null")}",
                          style: Theme.of(context).textTheme.bodyLarge,
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
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          "\$${(model.dailyMealPlan ?? "Null")}",
                          style: Theme.of(context).textTheme.bodyLarge,
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
