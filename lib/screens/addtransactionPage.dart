// ignore_for_file: file_names

import 'package:budgit/db/model/transaction.dart';
import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:budgit/widgets/dailyBudgetWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as tabbar;

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  var controller = TextEditingController(text: "0");

  List<String> listDaily = ['dailyPersonal', 'dailyMealPlan'];
  List<String> listBudget = ['personal', 'mealPlan'];

  int barValue = 0;
  int barGetter() => barValue;

  bool showMoreBanner = false;
  double controllerNumber = 0;

  @override
  void initState() {
    controller.addListener(_controllerListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (controller.text != "\$" && controller.text != "0") {
      String sub = controller.text.substring(1, controller.text.length);
      double tmp = double.parse(sub == "" ? "0" : sub);

      final model = Provider.of<AppStateModel>(context, listen: false);

      if (tmp >
          (barValue == 0
              ? (model.dailyPersonal ?? 0)
              : (model.dailyMealPlan ?? 0))) {
        setState(() {
          showMoreBanner = true;
          controllerNumber = tmp;
        });
      } else {
        setState(() {
          showMoreBanner = false;
          controllerNumber = tmp;
        });
      }
    } else {
      setState(() {
        showMoreBanner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final heightMultiplier = SizeConfig.heightMultiplier!;

    final model = Provider.of<AppStateModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.white,
            height: 16.5 * heightMultiplier,
          ),
          Positioned(
            top: 14 * heightMultiplier,
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
            top: 30.5 * heightMultiplier,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(60), right: Radius.circular(60)),
              child: Container(
                width: size.width,
                height: size.height / 1.5,
                color: AppColors.orange,
              ),
            ),
          ),
          SafeArea(
              child: Center(
            child: Column(
              children: [
                const DailyBudget(),
                SizedBox(
                  height: 3 * heightMultiplier,
                ),
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: showMoreBanner,
                    child: moreBanner(context, model, listBudget, barValue,
                        controllerNumber)),
                SizedBox(
                  width: size.width - 80,
                  child: TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.none,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.white,
                        fontSize: 5.5 * SizeConfig.textMultiplier!),
                    textAlign: TextAlign.end,
                    controller: controller,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 3.5 * heightMultiplier, left: 25, right: 25),
                  child: tabbar.CupertinoTabBar(
                    AppColors.beige,
                    AppColors.white,
                    [
                      Center(child: Text(LocaleKeys.personal.tr())),
                      const Center(child: Text("Meal Plan"))
                    ],
                    barGetter,
                    (index) {
                      setState(() {
                        barValue = index;
                        _controllerListener();
                      });
                    },
                    allowExpand: true,
                    useSeparators: true,
                    useShadow: false,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1.1 * heightMultiplier, horizontal: 10),
                  child: keyboard(context, controller),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.blue,
                            child: Text(
                              LocaleKeys.save.tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: AppColors.white),
                            ),
                            onPressed: () {
                              model.addTransaction(TransactionBudgit(
                                  transaction_time: DateTime.now(),
                                  amount: double.parse(controller.text
                                      .substring(1, controller.text.length)),
                                  account: listBudget[barValue]));
                              model.decreaseBudget(
                                  listBudget[barValue],
                                  double.parse(controller.text
                                      .substring(1, controller.text.length)));
                              model.decreaseDaily(
                                  listDaily[barValue],
                                  double.parse(controller.text
                                          .substring(1, controller.text.length))
                                      .toInt());

                              controller.text = "0";
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

Widget moreBanner(BuildContext context, AppStateModel model, List<String> list,
    int index, double value) {
  return Container(
    width: MediaQuery.of(context).size.width - 80,
    height: 4 * SizeConfig.heightMultiplier!,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white70,
    ),
    child: Text(
      "New Daily Balance: \$${model.predictNewDailyBudget(list[index], value)}",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.red, fontSize: 2.8 * SizeConfig.textMultiplier!),
    ),
  );
}

Widget keyboard(BuildContext context, TextEditingController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        children: [
          keyboardButton(
              context,
              controller,
              Text(
                "7",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "8",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "9",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
        ],
      ),
      Row(
        children: [
          keyboardButton(
              context,
              controller,
              Text(
                "4",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "5",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "6",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
        ],
      ),
      Row(
        children: [
          keyboardButton(
              context,
              controller,
              Text(
                "1",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "2",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "3",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
        ],
      ),
      Row(
        children: [
          keyboardButton(
              context,
              controller,
              Text(
                ".",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              Text(
                "0",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          keyboardButton(
              context,
              controller,
              const Icon(
                CupertinoIcons.delete_left,
                size: 20,
              )),
        ],
      )
    ],
  );
}

Widget keyboardButton(
    BuildContext context, TextEditingController controller, Widget text) {
  return GestureDetector(
    child: Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      width: 28.2 * SizeConfig.widthMultiplier!,
      height: 5.9 * SizeConfig.heightMultiplier!,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.beige, borderRadius: BorderRadius.circular(20)),
      child: text,
    ),
    onTap: () {
      if (text is Text) {
        if (controller.text != "0" || (text.data != "0" && text.data != ".")) {
          if (controller.text == "0") {
            controller.text = "\$";
          }
          if (text.data != "." || !controller.text.contains(".")) {
            if (controller.text.length < 8) {
              controller.text = "${controller.text}${text.data}";
            }
          }
        }
      } else {
        if (controller.text != "0") {
          controller.text =
              controller.text.substring(0, controller.text.length - 1);

          if (controller.text == "\$") {
            controller.text = "0";
          }
        }
      }
    },
  );
}
