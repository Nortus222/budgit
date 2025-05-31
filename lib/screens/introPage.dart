// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:budgit/widgets/mealPlanSettingsWidget.dart';
import 'package:budgit/widgets/personalSettingsWidget.dart';
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
    final heightMultiplier = SizeConfig.heightMultiplier!;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.white,
            height: 70 * heightMultiplier,
          ),
          Positioned(
            top: 22 * heightMultiplier,
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
            top: 50 * heightMultiplier,
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
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5 * heightMultiplier),
                  child: Text(
                    "Welcome to Budgit",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.5 * heightMultiplier),
                  child: Text("Enter initial data here",
                      style: Theme.of(context).textTheme.displayMedium),
                ),
                SizedBox(height: 1.5 * heightMultiplier),
                PersonalSettingsWidget(),
                SizedBox(
                  height: 0.5 * heightMultiplier,
                ),
                const MealPlanSettingsWidget(),
                Padding(
                  padding: EdgeInsets.only(
                      top: (4 * heightMultiplier), left: 20, right: 20),
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

                              model.calculateNewDailyBudget();

                              Navigator.of(context)
                                  .pushReplacementNamed('/home');
                            },
                            child: Text(
                              "Save",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
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
