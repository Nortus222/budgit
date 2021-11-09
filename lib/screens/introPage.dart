// ignore_for_file: file_names

import 'package:budgit/model/appStateModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);

    return Container(
        child: Center(
      child: TextButton(
          onPressed: () {
            model.setIsFirst();
            Navigator.of(context, rootNavigator: true)
                .pushReplacementNamed('/home');
          },
          child: Text("Save")),
    ));
  }
}
