// ignore_for_file: file_names

import 'package:budgit/db/model/transaction.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:budgit/db/transaction_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateModel extends foundation.ChangeNotifier {
  late TransactionDatabase db;

  late Future<List<TransactionBudgit>> list;

  late SharedPreferences sp;

  double? personal;
  double? mealPlan;
  DateTime? personalDue;
  DateTime? mealPlanDue;
  int? dailyPersonal;
  int? dailyMealPlan;

  int dbWeeks = 1;

  String dbAccount = "Personal";

  DateTime? appClosed;

  bool? isFirst;
  bool? isFirstToday;

  void init() async {
    db = TransactionDatabase.init();
    sp = await SharedPreferences.getInstance();

    loadAppClosed();
    loadIsFirst();
    loadTransactions();
    loadPreferences();
    loadDaily();
    //calculateNewDaily();
  }

  int daysBetween(DateTime day1, DateTime day2) {
    day1 = DateTime(day1.year, day1.month, day1.day);
    day2 = DateTime(day2.year, day2.month, day2.day);

    return (day1.difference(day2).inDays);
  }

  void loadDaily() {
    dailyPersonal = sp.getInt('dailyPersonal');
    dailyMealPlan = sp.getInt('dailyMealPlan');

    if (daysBetween(DateTime.now(), appClosed ?? DateTime.now()) >= 1) {
      print("New, Day");

      calculateNewDaily();

      setDaily('dailyPersonal', dailyPersonal ?? 0);
      setDaily('dailyMealPlan', dailyMealPlan ?? 0);
    } else {
      print("Same Day");
    }
  }

  void setDaily(String key, int value) {
    sp.setInt(key, value);
    if (key == 'dailyPersonal') {
      dailyPersonal = value;
    } else if (key == 'dailyMealPlan') {
      dailyMealPlan = value;
    }

    notifyListeners();
  }

  void calculateNewDaily() {
    dailyPersonal = (personal ?? 0) ~/
        daysBetween(personalDue ?? DateTime.now(), DateTime.now());

    dailyMealPlan = (mealPlan ?? 0) ~/
        daysBetween(mealPlanDue ?? DateTime.now(), DateTime.now());

    notifyListeners();
  }

  void loadPreferences() {
    personal = sp.getDouble('personal');
    mealPlan = sp.getDouble('mealPlan');

    String? personalDueString = sp.getString('personalDue');
    String? mealPlanDueString = sp.getString('mealPlanDue');

    personalDue = DateTime.tryParse(personalDueString ?? "");
    mealPlanDue = DateTime.tryParse(mealPlanDueString ?? "");
  }

  void setBudget(String key, double value) {
    sp.setDouble(key, value);
    if (key == 'personal') {
      personal = value;
    } else if (key == 'mealPlan') {
      mealPlan = value;
    }
    notifyListeners();
  }

  void setDueDate(String key, DateTime value) {
    sp.setString(key, value.toString());

    if (key == 'personalDue') {
      personalDue = value;
    } else if (key == 'mealPlanDue') {
      mealPlanDue = value;
    }
    notifyListeners();
  }

  void setAppClosed(String key, DateTime value) {
    sp.setString(key, value.toString());
  }

  void loadAppClosed() {
    appClosed = DateTime.tryParse(sp.getString('appClosed') ?? "");
  }

  void loadIsFirst() {
    isFirst = sp.getBool('isFirst') ?? true;
  }

  void setIsFirst(bool value) {
    sp.setBool('isFirst', value);
    isFirst = value;
  }

  void loadIsFirstToday() {
    isFirstToday = sp.getBool('isFirstToday') ?? true;
  }

  void setIsFirstToday(bool value) {
    sp.setBool('isFirstToday', value);
    isFirstToday = value;
  }

  void loadTransactions() {
    print("Weeks: $dbWeeks");
    list = db.readAll(dbWeeks, dbAccount);

    notifyListeners();
  }

  void dbShowMore() {
    list = db.readAll(++dbWeeks, dbAccount);

    notifyListeners();
  }

  void setDbAccount(String value) {
    dbAccount = value;

    loadTransactions();
  }

  void updateTransaction(TransactionBudgit transaction) {
    db.update(transaction);

    loadTransactions();
  }

  void addTransaction(TransactionBudgit transaction) {
    db.insert(transaction);

    loadTransactions();
  }

  void deleteTransaction(int id) {
    db.delete(id);

    loadTransactions();
  }

  Future<List<TransactionBudgit>> getTransactions() {
    return list;
  }
}
