// ignore_for_file: file_names

//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

  var now = DateTime.now();

  // Future<void> _showChangeDialog(BuildContext context, int index) async {
  //   var controller = TextEditingController();
  //   controller.text = list[index].toString();
  //   var copyNow = now;

  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(builder: (context, setState1) {
  //           return AlertDialog(
  //             title: const Text("Change Transaction"),
  //             content: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     const Text("Date: "),
  //                     TextButton(
  //                         onPressed: () {
  //                           DatePicker.showDatePicker(context,
  //                               showTitleActions: true,
  //                               minTime: DateTime(2020, 3, 5),
  //                               maxTime: DateTime(2021, 11, 11),
  //                               onConfirm: (date) {
  //                             setState1(() {
  //                               copyNow = date; //TODO
  //                             });
  //                           });
  //                         },
  //                         child: Text(
  //                             "${copyNow.day}/${copyNow.month}/${copyNow.year}")),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     const Text("Time: "),
  //                     TextButton(
  //                         onPressed: () {
  //                           DatePicker.showTime12hPicker(context,
  //                               showTitleActions: true, onConfirm: (date) {
  //                             setState1(() {
  //                               copyNow = date;
  //                             });
  //                           });
  //                         },
  //                         child: Text("${copyNow.hour}:${copyNow.minute}"))
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     const Text("Total: "),
  //                     Container(
  //                       padding: const EdgeInsetsDirectional.only(start: 15),
  //                       width: MediaQuery.of(context).size.width / 2,
  //                       child: TextFormField(
  //                         controller: controller,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("Cancel")),
  //               TextButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       list[index] = double.parse(controller.text);
  //                       now = copyNow;
  //                     });
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text("Save")),
  //             ],
  //           );
  //         });
  //       });
  // }

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
                child: Material(
                  child: FutureBuilder<List<TransactionBudgit>>(
                      future: list,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length, //TODO
                              itemBuilder: (BuildContext context, int index) {
                                return Dismissible(
                                  key: ValueKey<int>(
                                      snapshot.data![index].id!), //TODO
                                  direction: DismissDirection.endToStart,
                                  dismissThresholds: const {
                                    DismissDirection.endToStart: 0.99
                                  },
                                  confirmDismiss:
                                      (DismissDirection direction) async {
                                    return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirm"),
                                            content: const Text(
                                                "Are you sure you want to delete this item?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text("No")),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text("Delete"),
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.red)),
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
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 15),
                                  ),
                                  child: Card(
                                    child: ListTile(
                                        leading: const Text("Time"),
                                        title: Center(
                                            child: Text(
                                                "\$${snapshot.data![index].amount}")),
                                        trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 15,
                                            ),
                                            onPressed: () {}
                                            //_showChangeDialog(context, index),
                                            )),
                                  ),
                                  onDismissed: (DismissDirection direction) {
                                    db.delete(snapshot.data![index].id!);
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
              ))
            ],
          ),
        ),
      ),
    );
  }
}
