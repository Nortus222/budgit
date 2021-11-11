// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budgit/screens/settingsPage.dart';

class PersonalSettingsWidget extends StatelessWidget {
  PersonalSettingsWidget({Key? key}) : super(key: key);

  var format = NumberFormat.decimalPattern("en_US");

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Consumer<AppStateModel>(
          builder: (BuildContext context, model, child) {
        return Column(
          children: [
            Text(
              "Personal Budget",
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: AppColors.white),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "\$${format.format(model.personal ?? 0)}",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: AppColors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 10, bottom: 20, right: 10),
                    child: CupertinoButton(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(27)),
                        padding: const EdgeInsets.all(10),
                        color: AppColors.white,
                        child: Text(
                          "EDIT",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  color: AppColors.blue,
                                  fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          return await showChangeDialog(
                              context, 'personal', model);
                        }),
                  ),
                )
              ],
            ),
            Text(
              "Due",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: AppColors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('yMMMd')
                      .format(model.personalDue ?? DateTime.now()),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: AppColors.white),
                ),
                TextButton(
                  onPressed: () {
                    showDateTime(context, 'personalDue', model);
                  },
                  child: const Icon(Icons.calendar_today_rounded),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(AppColors.white),
                  ),
                )
              ],
            )
          ],
        );
      }),
    );
  }
}
