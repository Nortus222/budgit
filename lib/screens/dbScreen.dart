// ignore_for_file: avoid_unnecessary_containers, file_names, camel_case_types

import 'package:budgit/db/model/transaction.dart';
import 'package:budgit/model/appStateModel.dart';
import 'package:flutter/material.dart';
import 'package:budgit/db/transaction_database.dart';
import 'package:provider/provider.dart';

class DBscreen extends StatefulWidget {
  const DBscreen({Key? key}) : super(key: key);

  @override
  State<DBscreen> createState() => _DBscreenState();
}

class _DBscreenState extends State<DBscreen> {
  final db = TransactionDatabase.init();

  var list;

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    list = db.readAll(null, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final model = Provider.of<AppStateModel>(context);
    var list = model.getTransactions();

    return Scaffold(
        body: SafeArea(
      bottom: true,
      top: true,
      child: Column(
        children: [
          Center(
              child: Container(
            width: size.width - 80,
            height: 200,
            padding: const EdgeInsets.only(top: 100),
            child: TextFormField(
              controller: myController,
            ),
            // color: Colors.green,
          )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => {
                          model.addTransaction(TransactionBudgit(
                              transaction_time: DateTime.now(),
                              amount: (double.parse(myController.text == ""
                                  ? "0"
                                  : myController.text)),
                              account: "Personal")),
                          model.setBudget(
                              'personal',
                              (model.personal ?? 0) -
                                  double.parse(myController.text == ""
                                      ? "0"
                                      : myController.text)),
                          model.setDaily(
                              'dailyPersonal',
                              ((model.dailyPersonal ?? 0) -
                                      double.parse(myController.text == ""
                                          ? "0"
                                          : myController.text))
                                  .toInt()),
                          myController.clear()
                        },
                    child: const Text("Add")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () => {model.setIsFirst(true)},
                    child: const Text("Clear")),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: size.width - 80,
              child: FutureBuilder<List<TransactionBudgit>>(
                  future: list,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Center(
                                  child:
                                      Text('${snapshot.data![index].amount}')),
                            );
                          });
                    } else if (snapshot.hasError) {
                      print("Error\n\n");
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
    ));
  }
}
