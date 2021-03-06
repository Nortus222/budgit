// ignore_for_file: file_names

import 'package:budgit/utilites/screenConfig.dart';
import 'package:flutter/material.dart';

ThemeData BudgitTheme() {
  final ThemeData base = ThemeData.light();

  TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headline1: const TextStyle(
          fontSize: 36,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      headline2: const TextStyle(
          fontSize: 30,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w300),
      headline3: const TextStyle(
          fontSize: 26,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w300),
      headline4: const TextStyle(
          fontSize: 21, fontFamily: 'Roboto', color: Colors.black),
      bodyText1: const TextStyle(
          fontSize: 24,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      bodyText2: const TextStyle(
          fontSize: 16,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400),
    );
  }

  CardTheme _cardTheme(CardTheme base) {
    return base.copyWith(
      color: AppColors.beige,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  ButtonThemeData _buttonTheme(ButtonThemeData base) {
    return base.copyWith(
      buttonColor: AppColors.blue,
    );
  }

  AppBarTheme _appBarTheme(AppBarTheme base) {
    return base.copyWith(
        color: AppColors.beige,
        titleTextStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  return base.copyWith(
      //primaryColor: AppColors.blue,
      textTheme: _textTheme(base.textTheme),
      cardTheme: _cardTheme(base.cardTheme),
      buttonTheme: _buttonTheme(base.buttonTheme),
      appBarTheme: _appBarTheme(base.appBarTheme));
}

ThemeData BudgitThemeSmall() {
  final ThemeData base = ThemeData.light();

  TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      headline1: const TextStyle(
          fontSize: 33,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      headline2: const TextStyle(
          fontSize: 25,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w300),
      headline3: const TextStyle(
          fontSize: 20,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w300),
      headline4: const TextStyle(
          fontSize: 21, fontFamily: 'Roboto', color: Colors.black),
      bodyText1: TextStyle(
          fontSize: 2.8 * SizeConfig.textMultiplier!,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400),
      bodyText2: const TextStyle(
          fontSize: 16,
          fontFamily: 'Roboto',
          color: Colors.black,
          fontWeight: FontWeight.w400),
    );
  }

  CardTheme _cardTheme(CardTheme base) {
    return base.copyWith(
      color: AppColors.beige,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  ButtonThemeData _buttonTheme(ButtonThemeData base) {
    return base.copyWith(
      buttonColor: AppColors.blue,
    );
  }

  AppBarTheme _appBarTheme(AppBarTheme base) {
    return base.copyWith(
        color: AppColors.beige,
        titleTextStyle: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
  }

  return base.copyWith(
      //primaryColor: AppColors.blue,
      textTheme: _textTheme(base.textTheme),
      cardTheme: _cardTheme(base.cardTheme),
      buttonTheme: _buttonTheme(base.buttonTheme),
      appBarTheme: _appBarTheme(base.appBarTheme));
}

class AppColors {
  static const green = Color(0xff1ebf5d);
  static const orange = Color(0xfffda276);
  static const white = Color(0xffffffff);
  static const beige = Color(0xffece4da);
  static const blue = Color(0xff5971F0);

  static const yellow = Color(0xffFFB200);
  static const redChart = Color(0xffFD4E3F);
}
