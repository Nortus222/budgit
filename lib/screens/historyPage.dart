// ignore_for_file: file_names

//import 'dart:js';

import 'package:budgit/model/appStateModel.dart';
import 'package:budgit/screens/dbScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:budgit/db/transaction_database.dart';
import 'package:budgit/db/model/transaction.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<void> _showChangeDialog(BuildContext context, TransactionBudgit entry,
      AppStateModel model) async {
    var controller = TextEditingController();
    controller.text = entry.amount.toString();

    var selector = {
      "Personal": Text("Personal"),
      "Meal Plan": Text("Meal Plan")
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final model = Provider.of<AppStateModel>(context);
    final list = model.getTransactions();

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: true,
          top: true,
          child: Center(
            child: Column(
              children: [
                Container(
                  child: const Text(
                    "History",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 48,
                    ),
                  ),
                  padding: const EdgeInsetsDirectional.all(30),
                ),
                Expanded(
                  child: SizedBox(
                    width: size.width - 40,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: size.width - 40,
                          child: CupertinoSegmentedControl(children: const {
                            "Personal": Text(
                              "Rersonal",
                              style: TextStyle(fontSize: 12),
                            ),
                            "Mael Plan": Text("Meal Plan",
                                style: TextStyle(fontSize: 12))
                          }, onValueChanged: (key) {}),
                        ),
                        Expanded(
                          child: FutureBuilder<List<TransactionBudgit>>(
                              future: list,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Dismissible(
                                          key: ValueKey<int>(
                                              snapshot.data![index].id!),
                                          direction:
                                              DismissDirection.endToStart,
                                          dismissThresholds: const {
                                            DismissDirection.endToStart: 0.99
                                          },
                                          confirmDismiss: (DismissDirection
                                              direction) async {
                                            return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text("Confirm"),
                                                    content: const Text(
                                                        "Are you sure you want to delete this item?"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                          },
                                                          child:
                                                              const Text("No")),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                        },
                                                        child: const Text(
                                                            "Delete"),
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .red)),
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
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            padding: const EdgeInsetsDirectional
                                                .only(end: 15),
                                          ),
                                          child: Card(
                                            child: ListTile(
                                                leading: Text(
                                                    DateFormat('kk:mm:a')
                                                        .format(snapshot
                                                            .data![index]
                                                            .transaction_time)),
                                                title: Center(
                                                    child: Text(
                                                        "\$${snapshot.data![index].amount}")),
                                                trailing: IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 15,
                                                    ),
                                                    onPressed: () {
                                                      _showChangeDialog(
                                                          context,
                                                          snapshot.data![index],
                                                          model);
                                                    })),
                                          ),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            model.deleteTransaction(
                                                snapshot.data![index].id!);

                                            setState(() {});
                                          },
                                        );
                                      });
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
      ),
    );
  }
}
