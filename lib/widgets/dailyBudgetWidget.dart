// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DailyBudget extends StatelessWidget {
  const DailyBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
      child: Container(
          width: size.width - 40,
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text(
                "Available Today",
                style: TextStyle(fontSize: 36),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        "Personal",
                        style: TextStyle(fontSize: 21),
                      ),
                      Text(
                        "\$15",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width / 5,
                  ),
                  Column(
                    children: const [
                      Text(
                        "Meal Plan",
                        style: TextStyle(fontSize: 21),
                      ),
                      Text(
                        "\$21.75",
                        style: TextStyle(fontSize: 24),
                      )
                    ],
                  ),
                ],
              ),
            ]),
          )),
    );
  }
}
