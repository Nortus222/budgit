// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/inputValidator.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:budgit/widgets/mealPlanSettingsWidget.dart';
import 'package:budgit/widgets/personalSettingsWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //final model = Provider.of<AppStateModel>(context);

    var size = MediaQuery.of(context).size;
    final heightMultiplier = SizeConfig.heightMultiplier!;

    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
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
              height: 23 * heightMultiplier,
            ),
            Positioned(
              top: 16.5 * heightMultiplier,
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
              top: 44 * heightMultiplier,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(60), right: Radius.circular(60)),
                child: Container(
                  width: size.width,
                  height: size.height / 1.5,
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
                        height: 16.5 * heightMultiplier,
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.welcome_back.tr(),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      const PersonalSettingsWidget(),

                      SizedBox(
                        height: 2.5 * heightMultiplier,
                      ),
                      const MealPlanSettingsWidget(),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 2 * heightMultiplier, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoButton(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(27)),
                                  padding: const EdgeInsets.all(20),
                                  color: AppColors.blue,
                                  child: Text(
                                    LocaleKeys.save.tr(),
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
  var _key = GlobalKey<FormFieldState>();
  var controller = TextEditingController();

  if (type == 'personal') {
    controller.text = ((model.personal == null || model.personal! < 0)
        ? ""
        : model.personal!.toStringAsFixed(3));
  } else if (type == 'mealPlan') {
    controller.text = ((model.mealPlan == null || model.mealPlan! < 0)
        ? ""
        : model.mealPlan!.toStringAsFixed(3));
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Change $type budget"), //TODO
          content: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Text("Budget: "), //TODO
                Container(
                  padding: const EdgeInsetsDirectional.only(start: 5),
                  width: MediaQuery.of(context).size.width / 2.3,
                  child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    key: _key,
                    controller: controller,
                    validator: validateDecimal,
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
                child: Text(LocaleKeys.cancel.tr())),
            TextButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    model.setBudget(
                        type,
                        double.parse(
                            controller.text == '' ? "0" : controller.text));

                    model.calculateNewDailyBudget();

                    Navigator.of(context).pop();
                  }
                },
                child: Text(LocaleKeys.save.tr())),
          ],
        );
      });
}

// Future<DateTime?> showDateTime(
//     BuildContext context, String type, AppStateModel model) {
//   return DatePicker.showDatePicker(
//     context,
//     showTitleActions: true,
//     minTime: DateTime.now(),
//     maxTime:
//         DateTime((model.mealPlanDue?.year ?? DateTime.now().year) + 2, 1, 1),
//     onConfirm: (date) {
//       model.setDueDate(type, date);
//     },
//   );
// }
