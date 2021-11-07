// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          border: Border(),
          automaticallyImplyLeading: false,
          trailing: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.segment_rounded)),
        ),
        child: SafeArea(
          child: Center(
            child: Material(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 5,
                  ),
                  Container(
                    child: Column(
                      children: [
                        const Text(
                          "Personal Budget",
                          style: TextStyle(fontSize: 36),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("\$567.89",
                                  style: TextStyle(fontSize: 41)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, bottom: 20),
                              child: CupertinoButton.filled(
                                  child: const Text(
                                    "EDIT",
                                  ),
                                  onPressed: () {}),
                            )
                          ],
                        ),
                        const Text(
                          "Due",
                          style: TextStyle(fontSize: 24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("16 November 2021",
                                style: TextStyle(fontSize: 24)),
                            TextButton(
                                onPressed: () {},
                                child: const Icon(Icons.calendar_today_rounded))
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        const Text(
                          "Meal Plan",
                          style: TextStyle(fontSize: 36),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("\$1443.25",
                                  style: TextStyle(fontSize: 41)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: CupertinoButton.filled(
                                  child: const Text(
                                    "EDIT",
                                  ),
                                  onPressed: () {}),
                            )
                          ],
                        ),
                        const Text(
                          "Due",
                          style: TextStyle(fontSize: 24),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("11 December 2021",
                                style: TextStyle(fontSize: 24)),
                            TextButton(
                                onPressed: () {},
                                child: const Icon(Icons.calendar_today_rounded))
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: CupertinoButton.filled(
                        child: const Text(
                          "Save",
                        ),
                        onPressed: () {}),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
