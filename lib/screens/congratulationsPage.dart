// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/daysBetween.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage({Key? key}) : super(key: key);

  @override
  State<CongratulationsPage> createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    _confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<AppStateModel>(context);

    print(daysBetween(DateTime.now(), model.getAppClosed() ?? DateTime.now()));

    final newDaily = (model.dailyPersonal ?? 0) +
        daysBetween(DateTime.now(), model.getAppClosed() ?? DateTime.now()) *
            (model.dailyPersonalBudget ?? 0);

    return Material(
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        gravity: 0.05,
        numberOfParticles: 50,
        emissionFrequency: 0.05,
        particleDrag: 0.05,
        colors: [
          Colors.red,
          Colors.blue,
          Colors.amber,
          Colors.orange,
          Colors.pink,
          Colors.purple
        ],
        child: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Text(
                "Congratulations",
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height / 3,
            ),
            Text(
              "You saved \$${model.dailyPersonal} yesterday",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: AppColors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Spend it Today?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Today's budget will be: \$$newDaily",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.blue,
                              child: Text(
                                "Spend Today",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(color: AppColors.white),
                              ),
                              onPressed: () {
                                model.setAppClosed('appClosed', DateTime.now());
                                model.setDaily('dailyPersonal', newDaily);

                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Keep it?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Daily budget will be: \$${(model.predictNewDailyBudget('personal', 0))}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.blue,
                              child: Text(
                                "Keep it",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(color: AppColors.white),
                              ),
                              onPressed: () {
                                model.setAppClosed('appClosed', DateTime.now());
                                model.calculateNewDailyBudget();

                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      ),
      color: AppColors.green,
    );
  }
}
