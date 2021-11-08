// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemainingBudget extends StatelessWidget {
  const RemainingBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(child:
        Consumer<AppStateModel>(builder: (BuildContext context, model, chid) {
      return Column(
        children: [
          const Text(
            "Remaining Budget",
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "Personal",
                    style: TextStyle(fontSize: 26),
                  ),
                  Text(
                    "\$${(model.personal ?? "Null")}",
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${(model.personalDue ?? DateTime.now()).difference(DateTime.now()).inDays} days left",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                width: size.width / 6,
              ),
              Column(
                children: [
                  const Text(
                    "Meal Plan",
                    style: TextStyle(fontSize: 26),
                  ),
                  Text(
                    "\$${(model.mealPlan ?? "Null")}",
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${(model.mealPlanDue ?? DateTime.now()).difference(DateTime.now()).inDays} days left",
                    style: TextStyle(fontSize: 16),
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
