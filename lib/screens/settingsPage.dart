// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);

    var size = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          border: const Border(),
          automaticallyImplyLeading: false,
          trailing: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.segment_rounded)),
        ),
        child: SafeArea(
          child: Center(
            child: Material(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 5,
                  ),
                  Column(
                    children: [
                      const Text(
                        "Personal Budget",
                        style: TextStyle(fontSize: 36),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text("\$${(model.personal ?? "Null")}",
                                style: const TextStyle(fontSize: 41)),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, bottom: 20, right: 10),
                              child: CupertinoButton.filled(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(27)),
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    "EDIT",
                                  ),
                                  onPressed: () async {
                                    return await showChangeDialog(
                                        context, 'personal', model);
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
                                  .format(model.personalDue ?? DateTime.now()),
                              style: const TextStyle(fontSize: 24)),
                          TextButton(
                              onPressed: () {
                                showDateTime(context, 'personalDue', model);
                              },
                              child: const Icon(Icons.calendar_today_rounded))
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(27)),
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
                                DateFormat('yMMMd').format(
                                    model.mealPlanDue ?? DateTime.now()),
                                style: const TextStyle(fontSize: 24)),
                            TextButton(
                                onPressed: () {
                                  showDateTime(context, 'mealPlanDue', model);
                                },
                                child: const Icon(Icons.calendar_today_rounded))
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: CupertinoButton.filled(
                        child: const Text(
                          "Save",
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

Future<void> showChangeDialog(
    BuildContext context, String type, AppStateModel model) async {
  var controller = TextEditingController();

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change $type budget"),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text("Budget: "),
                Container(
                  padding: const EdgeInsetsDirectional.only(start: 15),
                  width: MediaQuery.of(context).size.width / 3,
                  child: TextFormField(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  model.setBudget(
                      type,
                      double.parse(
                          controller.text == '' ? "0" : controller.text));
                  Navigator.of(context).pop();
                },
                child: const Text("Save")),
          ],
        );
      });
}

Future<DateTime?> showDateTime(
    BuildContext context, String type, AppStateModel model) {
  return DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime:
        DateTime((model.mealPlanDue?.year ?? DateTime.now().year) - 2, 1, 1),
    maxTime:
        DateTime((model.mealPlanDue?.year ?? DateTime.now().year) + 2, 1, 1),
    onConfirm: (date) {
      model.setDueDate(type, date);
    },
  );
}
