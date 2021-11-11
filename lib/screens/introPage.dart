// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/widgets/mealPlanSettingsWidget.dart';
import 'package:budgit/widgets/personalSettingsWidget.dart';
import 'package:budgit/widgets/remainingBudgetWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.white,
            height: 140,
          ),
          Positioned(
            top: size.height / 3.4,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(60), right: Radius.circular(60)),
              child: Container(
                width: size.width,
                height: size.height / 2,
                color: AppColors.green,
              ),
            ),
          ),
          Positioned(
            top: size.height / 1.75,
            child: ClipRRect(
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(60), right: Radius.circular(60)),
              child: Container(
                width: size.width,
                height: size.height / 2 + 100,
                color: AppColors.beige,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: size.height / 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Welcome to Budgit",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Text(
                  "Enter initial data here",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(fontSize: 28),
                ),
                SizedBox(height: size.height / 25),
                const PersonalSettingsWidget(),
                SizedBox(
                  height: size.height / 30,
                ),
                const MealPlanSettingsWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(27)),
                            padding: const EdgeInsets.all(20),
                            color: AppColors.blue,
                            onPressed: () {
                              model.setIsFirst(false);
                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            },
                            child: Text(
                              "Save",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: AppColors.white),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
