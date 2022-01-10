// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budgit/screens/settingsPage.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class PersonalSettingsWidget extends StatelessWidget {
  const PersonalSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightMultiplier = SizeConfig.heightMultiplier!;
    var format = NumberFormat.decimalPattern(context.locale.languageCode);

    return Material(
      color: Colors.transparent,
      child: Consumer<AppStateModel>(
          builder: (BuildContext context, model, child) {
        return Column(
          children: [
            Text(
              LocaleKeys.personal.tr(),
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: AppColors.white),
            ),
            Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3 * heightMultiplier),
                  child: Text(
                    (model.personal ?? -1) > 0
                        ? "\$${format.format(model.personal ?? 0)}"
                        : LocaleKeys.spent.tr(),
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: (model.personal ?? -1) > 0
                            ? AppColors.white
                            : Colors.red),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 2.5 * heightMultiplier,
                        left: 10,
                        bottom: 15,
                        right: 10),
                    child: CupertinoButton(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(27)),
                        padding: const EdgeInsets.all(10),
                        color: AppColors.white,
                        child: Text(
                          LocaleKeys.edit.tr(),
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
              LocaleKeys.due.tr(),
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
