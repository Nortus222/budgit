// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RemainingBudget extends StatelessWidget {
  const RemainingBudget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Material(
        child: Container(
      child: Column(
        children: [
          const Text(
            "Remaining Budget",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "Personal",
                    style: TextStyle(fontSize: 26),
                  ),
                  Text(
                    "\$567.89",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "23 days left",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                width: size.width / 6,
              ),
              Column(
                children: [
                  const Text(
                    "Meal Plan",
                    style: TextStyle(fontSize: 26),
                  ),
                  Text(
                    "\$1445.23",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "63 days left",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
