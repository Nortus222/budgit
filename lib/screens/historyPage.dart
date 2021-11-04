// ignore_for_file: file_names

//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:budgit/db/transaction_database.dart';
import 'package:budgit/db/model/transaction.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var list;
  final db = TransactionDatabase.init();

  @override
  void initState() {
    print("Init\n");
    list = db.readAll();
  }

  Future<void> _showChangeDialog(
      BuildContext context, TransactionBudgit entry) async {
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

    // print(transaction.account);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState1) {
            return AlertDialog(
              title: const Text("Change Transaction"),
              content: Column(
                children: [
                  Row(
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
                          child: Text(
                              "${transaction.transaction_time.day}/${transaction.transaction_time.month}/${transaction.transaction_time.year}")),
                    ],
                  ),
                  Row(
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
                          child: Text(
                              "${transaction.transaction_time.hour}:${transaction.transaction_time.minute}"))
                    ],
                  ),
                  Row(children: [
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
                  Row(
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
                      setState(() {
                        transaction.amount = double.parse(
                            controller.text == '' ? "0" : controller.text);
                        db.update(transaction);
                        //now = copyNow;
                        list = db.readAll();
                      });
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

    return Container(
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
                  ),
                ),
                padding: const EdgeInsetsDirectional.all(30),
              ),
              Expanded(
                child: Container(
                  width: size.width - 40,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: size.width - 40,
                        child: CupertinoSegmentedControl(children: const {
                          "Personal": Text(
                            "Rersonal",
                            style: TextStyle(fontSize: 12),
                          ),
                          "Mael Plan":
                              Text("Meal Plan", style: TextStyle(fontSize: 12))
                        }, onValueChanged: (key) {}),
                      ),
                      Expanded(
                        child: Material(
                          child: FutureBuilder<List<TransactionBudgit>>(
                              future: list,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length, //TODO
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Dismissible(
                                          key: ValueKey<int>(
                                              snapshot.data![index].id!), //TODO
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
                                                    '${snapshot.data![index].transaction_time.hour}:${snapshot.data![index].transaction_time.minute}'),
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
                                                          snapshot
                                                              .data![index]);
                                                    })),
                                          ),
                                          onDismissed:
                                              (DismissDirection direction) {
                                            db.delete(
                                                snapshot.data![index].id!);
                                            //list = db.readAll();
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
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
