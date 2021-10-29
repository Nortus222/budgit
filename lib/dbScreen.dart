// ignore_for_file: avoid_unnecessary_containers, file_names, camel_case_types

import 'package:flutter/material.dart';

class DBscreen extends StatefulWidget {
  const DBscreen({Key? key}) : super(key: key);

  @override
  State<DBscreen> createState() => _DBscreenState();
}

class _DBscreenState extends State<DBscreen> {
  var list = [1.0, 2]; //Get this from DB

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
      bottom: true,
      top: true,
      child: Column(
        children: [
          Center(
              child: Container(
            child: TextFormField(
              controller: myController,
            ),
            width: size.width - 80,
            height: 200,
            padding: const EdgeInsets.only(top: 100),
            // color: Colors.green,
          )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ElevatedButton(
                    onPressed: () => {
                          setState(() {
                            list.add((double.parse(myController.text == ""
                                ? "0"
                                : myController.text)));
                          }),
                          myController.clear()
                        },
                    child: const Text("Add")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () => {
                          setState(() {
                            list.clear();
                          })
                        },
                    child: const Text("Clear")),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          Expanded(
            child: SizedBox(
              width: size.width - 80,
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Center(child: Text('${list[index]}')),
                    );
                  }),
            ),
          ),
        ],
      ),
    ));
  }
}
