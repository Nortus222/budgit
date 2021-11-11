// ignore_for_file: file_names

//import 'dart:js';

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/dbScreen.dart';
import 'package:budgit/theme/themeData.dart';
import 'package:budgit/widgets/persistanceHeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:budgit/db/transaction_database.dart';
import 'package:budgit/db/model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

    final model = Provider.of<AppStateModel>(context);
    final list = model.getTransactions();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.white,
            height: 140,
          ),
          Positioned(
            top: 115,
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
                    child: Text(
                      "History",
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsetsDirectional.all(30),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: size.width - 40,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 10),
                            child: tabbar.CupertinoTabBar(
                              AppColors.beige,
                              AppColors.white,
                              const [
                                Center(child: Text("Personal")),
                                Center(child: Text("Meal Plan"))
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

    var text;

    final size = MediaQuery.of(context).size;

    int daysBetween(DateTime day1, DateTime day2) {
      day1 = DateTime(day1.year, day1.month, day1.day);
      day2 = DateTime(day2.year, day2.month, day2.day);

      return (day1.difference(day2).inDays);
    }

    if (daysBetween(DateTime.now(), dateFirst) == 0) {
      text = const Text("Today");
    } else if (daysBetween(DateTime.now(), dateFirst) == 1) {
      text = const Text("Yesterday");
    } else {
      text = Text(DateFormat('MMMMd').format(list.first.transaction_time));
    }

    sliverList.add(CustomHeader(AppColors.orange, text));

    list.forEach((element) {
      if (daysBetween(DateTime.now(), element.transaction_time) == 0) {
        text = const Text("Today");
      } else if (daysBetween(DateTime.now(), element.transaction_time) == 1) {
        text = const Text("Yesterday");
      } else {
        text = Text(DateFormat('MMMMd').format(element.transaction_time));
      }

      if (daysBetween(dateFirst, element.transaction_time) != 0) {
        sliverList.add(CustomHeader(AppColors.orange, text));
        sliverList
            .add(SliverToBoxAdapter(child: _listTile(context, element, model)));
        dateFirst = element.transaction_time;
      } else {
        sliverList
            .add(SliverToBoxAdapter(child: _listTile(context, element, model)));
      }
    });

    sliverList.add(SliverToBoxAdapter(
      child: Card(
        color: AppColors.blue,
        child: TextButton(
            onPressed: () {
              model.dbShowMore();
            },
            child: Text(
              "Show More",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: AppColors.white),
            )),
      ),
    ));
    return sliverList;
  }

  Widget _listTile(
      BuildContext context, TransactionBudgit entry, AppStateModel model) {
    return Dismissible(
      key: ValueKey<int>(entry.id!),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.99},
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content:
                    const Text("Are you sure you want to delete this item?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No")),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Delete"),
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.red)),
                  ),
                ],
              );
            });
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          size: 25,
        ),
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: 15),
      ),
      child: Card(
        child: SizedBox(
          height: 60,
          child: ListTile(
              leading:
                  Text(DateFormat('kk:mm:a').format(entry.transaction_time)),
              title: Center(
                  child: Text(
                "\$${entry.amount}",
                style: Theme.of(context).textTheme.bodyText2,
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
      onDismissed: (DismissDirection direction) {
        model.deleteTransaction(entry.id!);

        setState(() {});
      },
    );
  }

  Widget showEmptyList(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "No Transactions yet",
        style: Theme.of(context)
            .textTheme
            .headline2!
            .copyWith(color: Colors.greenAccent),
      ),
    );
  }

  Future<void> _showChangeDialog(BuildContext context, TransactionBudgit entry,
      AppStateModel model) async {
    var controller = TextEditingController();
    controller.text = entry.amount.toString();

    var selector = {
      "Personal": const Text("Personal"),
      "Meal Plan": const Text("Meal Plan")
    };

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
              title: const Text("Change Transaction"),
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Date: "),
                        TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(
                                      transaction.transaction_time.year - 2,
                                      1,
                                      1),
                                  maxTime: DateTime(
                                      transaction.transaction_time.year + 2,
                                      1,
                                      1), onConfirm: (date) {
                                setState1(() {
                                  transaction.transaction_time = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      transaction.transaction_time.hour,
                                      transaction.transaction_time.minute,
                                      transaction.transaction_time.second,
                                      transaction.transaction_time.millisecond,
                                      transaction.transaction_time.microsecond);
                                });
                              });
                            },
                            child: Text(DateFormat('MM/dd/yyyy')
                                .format(transaction.transaction_time))),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Time: "),
                        TextButton(
                            onPressed: () {
                              DatePicker.showTime12hPicker(context,
                                  showTitleActions: true, onConfirm: (date) {
                                setState1(() {
                                  transaction.transaction_time = DateTime(
                                      transaction.transaction_time.year,
                                      transaction.transaction_time.month,
                                      transaction.transaction_time.day,
                                      date.hour,
                                      date.minute,
                                      DateTime.now().second,
                                      DateTime.now().millisecond,
                                      DateTime.now().microsecond);
                                });
                              });
                            },
                            child: Text(DateFormat('kk:mm:a')
                                .format(transaction.transaction_time))),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                    child: Row(children: [
                      const Text("Account: "),
                      CupertinoSegmentedControl(
                          children: selector,
                          groupValue: transaction.account,
                          onValueChanged: (key) {
                            setState1(() {
                              transaction.account = key.toString();
                            });
                          })
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text("Total: "),
                        Container(
                          padding: const EdgeInsetsDirectional.only(start: 15),
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            controller: controller,
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
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      transaction.amount = double.parse(
                          controller.text == '' ? "0" : controller.text);
                      model.updateTransaction(transaction);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Save")),
              ],
            );
          });
        });
  }
}
