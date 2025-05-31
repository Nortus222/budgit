// ignore_for_file: file_names

import 'dart:async';

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/utilites/inputValidator.dart';
import 'package:budgit/utilites/screenConfig.dart';
import 'package:budgit/widgets/persistanceHeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:budgit/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:budgit/db/model/transaction.dart';
import 'package:provider/provider.dart';
import 'package:budgit/utilites/daysBetween.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart' as tabbar;

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> listBudget = ['personal', 'mealPlan'];

  int barValue = 0;
  int barGetter() => barValue;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final heightMultiplier = SizeConfig.heightMultiplier!;

    final model = Provider.of<AppStateModel>(context);
    final list = model.getTransactions();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.white,
            height: 16.5 * heightMultiplier,
          ),
          Positioned(
            top: 13.5 * heightMultiplier,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(60), right: Radius.circular(60)),
              child: Container(
                width: size.width,
                height: size.height,
                color: AppColors.green,
              ),
            ),
          ),
          SafeArea(
            bottom: true,
            top: true,
            child: Center(
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 3.5 * heightMultiplier, horizontal: 30),
                      child: Text(
                        LocaleKeys.histotry.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                fontSize: 48, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: SizedBox(
                      width: size.width - 40,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.4 * heightMultiplier,
                                bottom: 1.18 * heightMultiplier),
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
                                });
                                model.setDbAccount(listBudget[barValue]);
                              },
                              allowExpand: true,
                              useSeparators: true,
                              useShadow: false,
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          Expanded(
                            child: FutureBuilder<List<TransactionBudgit>>(
                                future: list,
                                initialData: null,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.isEmpty) {
                                      return showEmptyList(context);
                                    } else {
                                      return CustomScrollView(
                                        slivers: _getSlivers(
                                            context, snapshot.data!, model),
                                      );
                                    }
                                  } else if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  } else {
                                    return Container(
                                      alignment: AlignmentDirectional.center,
                                      child: const CircularProgressIndicator(),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getSlivers(
      BuildContext context, List<TransactionBudgit> list, AppStateModel model) {
    var dateFirst = list.first.transaction_time;

    List<Widget> sliverList = [];

    Text text;

    if (daysBetween(DateTime.now(), dateFirst) == 0) {
      text = Text(LocaleKeys.today.tr());
    } else if (daysBetween(DateTime.now(), dateFirst) == 1) {
      text = Text(LocaleKeys.yesterday.tr());
    } else {
      text = Text(DateFormat('MMMMd').format(list.first.transaction_time));
    }

    sliverList.add(CustomHeader(AppColors.orange, text));

    for (var element in list) {
      if (daysBetween(DateTime.now(), element.transaction_time) == 0) {
        text = Text(LocaleKeys.today.tr());
      } else if (daysBetween(DateTime.now(), element.transaction_time) == 1) {
        text = Text(LocaleKeys.yesterday.tr());
      } else {
        text = Text(DateFormat('MMMMd').format(element.transaction_time));
      }

      if (daysBetween(dateFirst, element.transaction_time) != 0) {
        sliverList.add(CustomHeader(AppColors.orange, text));
        sliverList.add(SliverToBoxAdapter(
            child: _listTile(context, element, model, list)));
        dateFirst = element.transaction_time;
      } else {
        sliverList.add(SliverToBoxAdapter(
            child: _listTile(context, element, model, list)));
      }
    }

    sliverList.add(SliverToBoxAdapter(
      child: Card(
        color: AppColors.blue,
        child: TextButton(
            onPressed: () {
              model.dbShowMore();
            },
            child: Text(
              LocaleKeys.show_more.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.white),
            )),
      ),
    ));
    return sliverList;
  }

  Widget _listTile(BuildContext context, TransactionBudgit entry,
      AppStateModel model, List<TransactionBudgit> list) {
    return Dismissible(
      key: ValueKey<int>(entry.id!),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.99},
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(LocaleKeys.confirm.tr()),
                content: Text(LocaleKeys.you_sure.tr()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(LocaleKeys.no.tr())),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(LocaleKeys.delete.tr()),
                    style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all(Colors.red)),
                    child: const Text("Delete"),
                  ),
                ],
              );
            });
      },
      background: Container(
        color: Colors.red,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 15),
        child: const Icon(
          Icons.delete,
          size: 25,
        ),
      ),
      child: Card(
        child: SizedBox(
          height: 60,
          child: ListTile(
              leading: Text(DateFormat.jm().format(entry.transaction_time)),
              title: Center(
                  child: Text(
                "\$${entry.amount}",
                style: Theme.of(context).textTheme.bodyMedium,
              )),
              trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    _showChangeDialog(context, entry, model);
                  })),
        ),
      ),
      onDismissed: (DismissDirection direction) async {
        list.remove(entry);
        if (daysBetween(DateTime.now(), entry.transaction_time) < 8) {
          model.decreaseBudget(entry.account, -entry.amount);
          if (daysBetween(DateTime.now(), entry.transaction_time) == 0) {
            model.decreaseDaily(
                entry.account == 'personal' ? 'dailyPersonal' : 'dailyMealPlan',
                -(entry.amount.toInt()));
          }
        }
        model.deleteTransaction(entry.id!);
      },
    );
  }

  Widget showEmptyList(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        LocaleKeys.no_transactions_yet.tr(),
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(color: Colors.greenAccent),
      ),
    );
  }

  Future<void> _showChangeDialog(BuildContext context, TransactionBudgit entry,
      AppStateModel model) async {
    var controller = TextEditingController();
    controller.text = entry.amount.toString();

    var key = GlobalKey<FormFieldState>();

    int newBarValue = entry.account == 'personal' ? 0 : 1;
    newBarGetter() => newBarValue;

    TransactionBudgit transaction = TransactionBudgit(
        id: entry.id,
        transaction_time: entry.transaction_time,
        amount: entry.amount,
        account: entry.account);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState1) {
            return AlertDialog(
              scrollable: true,
              title: Text(LocaleKeys.change_transaction.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(LocaleKeys.date.tr() + ": "),
                        TextButton(
                            onPressed: () {
                              // DatePicker.showDatePicker(context,
                              //     showTitleActions: true,
                              //     minTime: DateTime(
                              //         transaction.transaction_time.year - 2,
                              //         1,
                              //         1),
                              //     maxTime: DateTime(
                              //         transaction.transaction_time.year + 2,
                              //         1,
                              //         1), onConfirm: (date) {
                              //   setState1(() {
                              //     transaction.transaction_time = DateTime(
                              //         date.year,
                              //         date.month,
                              //         date.day,
                              //         transaction.transaction_time.hour,
                              //         transaction.transaction_time.minute,
                              //         transaction.transaction_time.second,
                              //         transaction.transaction_time.millisecond,
                              //         transaction.transaction_time.microsecond);
                              //   });
                              // });
                            },
                            child: Text(DateFormat.yMd()
                                .format(transaction.transaction_time))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(LocaleKeys.time.tr() + ": "),
                        TextButton(
                            onPressed: () {
                              // DatePicker.showTime12hPicker(context,
                              //     showTitleActions: true, onConfirm: (date) {
                              //   setState1(() {
                              //     transaction.transaction_time = DateTime(
                              //         transaction.transaction_time.year,
                              //         transaction.transaction_time.month,
                              //         transaction.transaction_time.day,
                              //         date.hour,
                              //         date.minute,
                              //         DateTime.now().second,
                              //         DateTime.now().millisecond,
                              //         DateTime.now().microsecond);
                              //   });
                              // });
                            },
                            child: Text(DateFormat.jm()
                                .format(transaction.transaction_time))),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Row(children: [
                      Text(LocaleKeys.account.tr() + ": "),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20.5,
                        child: tabbar.CupertinoTabBar(
                          AppColors.beige,
                          AppColors.white,
                          [
                            Center(child: Text(LocaleKeys.personal.tr())),
                            const Center(child: Text("Meal Plan"))
                          ],
                          newBarGetter,
                          (index) {
                            setState1(() {
                              newBarValue = index;
                            });
                            transaction.account = listBudget[newBarValue];
                          },
                          allowExpand: true,
                          useSeparators: true,
                          useShadow: false,
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(LocaleKeys.total.tr() + ": "),
                        Container(
                          padding: const EdgeInsetsDirectional.only(start: 15),
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            key: key,
                            controller: controller,
                            validator: validateDecimal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(LocaleKeys.cancel.tr())),
                TextButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        transaction.amount = double.parse(
                            controller.text == '' ? "0" : controller.text);

                        //double diff = transaction.amount - entry.amount;

                        if (daysBetween(
                                DateTime.now(), entry.transaction_time) ==
                            0) {
                          print("Today");
                          model.decreaseBudget(entry.account, -entry.amount);
                          model.decreaseDaily(
                              entry.account == 'personal'
                                  ? 'dailyPersonal'
                                  : 'dailyMealPlan',
                              -entry.amount.toInt());

                          model.decreaseBudget(
                              transaction.account, transaction.amount);
                        } else {
                          model.decreaseBudget(entry.account, -entry.amount);

                          model.decreaseBudget(
                              transaction.account, transaction.amount);
                        }

                        if (daysBetween(
                                DateTime.now(), transaction.transaction_time) ==
                            0) {
                          model.decreaseDaily(
                              transaction.account == 'personal'
                                  ? 'dailyPersonal'
                                  : 'dailyMealPlan',
                              transaction.amount.toInt());
                        }

                        model.updateTransaction(transaction);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(LocaleKeys.save.tr())),
              ],
            );
          });
        });
  }
}
