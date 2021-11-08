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
      child: Consumer<AppStateModel>(
          builder: (BuildContext context, model, child) {
        return Container(
            width: size.width - 40,
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text(
                  "Available Today",
                  style: TextStyle(fontSize: 36),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Personal",
                          style: TextStyle(fontSize: 21),
                        ),
                        Text(
                          "\$${(model.dailyPersonal ?? "Null")}",
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width / 5,
                    ),
                    Column(
                      children: [
                        const Text(
                          "Meal Plan",
                          style: TextStyle(fontSize: 21),
                        ),
                        Text(
                          "\$${(model.dailyMealPlan ?? "Null")}",
                          style: const TextStyle(fontSize: 24),
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
