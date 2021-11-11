// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/widgets/mealPlanSettingsWidget.dart';
import 'package:budgit/widgets/personalSettingsWidget.dart';
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
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          trailing: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.segment_rounded),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(AppColors.blue)),
          ),
        ),
        child: Stack(
          children: [
            Container(
              color: AppColors.white,
              height: 200,
            ),
            Positioned(
              top: size.height / 5.1,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(60), right: Radius.circular(60)),
                child: Container(
                  width: size.width,
                  height: size.height / 2,
                  color: AppColors.green,
                ),
              ),
            ),
            Positioned(
              top: size.height / 2.15,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(60), right: Radius.circular(60)),
                child: Container(
                  width: size.width,
                  height: size.height / 2 + 100,
                  color: AppColors.beige,
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        height: size.height / 5,
                        alignment: Alignment.center,
                        child: Text(
                          "Welcome Back",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      const PersonalSettingsWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      const MealPlanSettingsWidget(),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(27)),
                                  padding: const EdgeInsets.all(20),
                                  color: AppColors.blue,
                                  child: Text(
                                    "Save",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: AppColors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
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
                  model.calculateNewDailyBudget();
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
