// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MealPlanSettingsWidget extends StatelessWidget {
  const MealPlanSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child:
        Consumer<AppStateModel>(builder: (BuildContext context, model, child) {
      return Column(
        children: [
          const Text(
            "Meal Plan",
            style: TextStyle(fontSize: 36),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("\$${(model.mealPlan ?? "Null")}",
                    style: const TextStyle(fontSize: 41)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 10, right: 10),
                  child: CupertinoButton.filled(
                      borderRadius: const BorderRadius.all(Radius.circular(27)),
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        "EDIT",
                      ),
                      onPressed: () async {
                        return await showChangeDialog(
                            context, 'mealPlan', model);
                      }),
                ),
              )
            ],
          ),
          const Text(
            "Due",
            style: TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  DateFormat('yMMMd')
                      .format(model.mealPlanDue ?? DateTime.now()),
                  style: const TextStyle(fontSize: 24)),
              TextButton(
                  onPressed: () {
                    showDateTime(context, 'mealPlanDue', model);
                  },
                  child: const Icon(Icons.calendar_today_rounded))
            ],
          )
        ],
      );
    }));
  }
}
