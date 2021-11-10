// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/widgets/mealPlanSettingsWidget.dart';
import 'package:budgit/widgets/personalSettingsWidget.dart';
import 'package:budgit/widgets/remainingBudgetWidget.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Welcome to Budgit",
                style: TextStyle(fontSize: 36),
              ),
            ),
            Text(
              "Enter initial data here",
              style: TextStyle(fontSize: 26),
            ),
            SizedBox(height: size.height / 6),
            PersonalSettingsWidget(),
            MealPlanSettingsWidget(),
            TextButton(
                onPressed: () {
                  model.setIsFirst(false);
                },
                child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
