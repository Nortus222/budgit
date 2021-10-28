// ignore_for_file: file_names

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<double> list =
      List.generate(50, (index) => index + (index % 5) / 10); // DB goes here

  Future<void> _showChangeDialog(BuildContext context, int index) async {
    var controller = TextEditingController();
    controller.text = list[index].toString();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Change Transaction"),
            content: Column(
              children: [
                const Text("Date: "),
                const Text("Time: "),
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
                      list[index] = double.parse(controller.text);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        children: [
          Container(
            child: const Text("History"),
            margin: const EdgeInsetsDirectional.all(30),
          ),
          Expanded(
              child: Container(
            width: size.width - 180,
            child: Material(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: ValueKey<double>(list[index]),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        child: const Text("Delete"),
                        alignment: AlignmentDirectional.centerEnd,
                        padding: const EdgeInsetsDirectional.only(end: 15),
                      ),
                      child: Card(
                        child: ListTile(
                            leading: const Text("Time"),
                            title: Center(child: Text("\$${list[index]}")),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 15,
                              ),
                              onPressed: () =>
                                  _showChangeDialog(context, index),
                            )),
                      ),
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          list.removeAt(index);
                        });
                      },
                    );
                  }),
            ),
          ))
        ],
      ),
    );
  }
}
