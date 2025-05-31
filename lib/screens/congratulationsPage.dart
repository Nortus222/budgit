// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/daysBetween.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage({Key? key}) : super(key: key);

  @override
  State<CongratulationsPage> createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final model = Provider.of<AppStateModel>(context);

    print(daysBetween(DateTime.now(), model.getAppClosed() ?? DateTime.now()));

    final newDaily = (model.dailyPersonal ?? 0) +
        daysBetween(DateTime.now(), model.getAppClosed() ?? DateTime.now()) *
            (model.dailyPersonalBudget ?? 0);

    return Material(
      color: AppColors.green,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        gravity: 0.05,
        numberOfParticles: 50,
        emissionFrequency: 0.05,
        particleDrag: 0.05,
        colors: const [
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
                LocaleKeys.congratulations.tr(),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: AppColors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height / 3,
            ),
            Text(
              "You saved \$${model.dailyPersonal} yesterday", //TODO
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: AppColors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      LocaleKeys.spend_it_today.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Today's budget will be: \$$newDaily", //TODO
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
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
                                LocaleKeys.spend_today.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
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
                      LocaleKeys.keep_it.tr() + "?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Daily budget will be: \$${(model.predictNewDailyBudget('personal', 0))}", //TODO
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
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
                                LocaleKeys.keep_it.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
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
    );
  }
}
