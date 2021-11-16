// ignore_for_file: file_names

import 'package:budgit/db/model/transaction.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:budgit/db/transaction_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:budgit/utilites/daysBetween.dart';

class AppStateModel extends foundation.ChangeNotifier {
  late TransactionDatabase db;

  Future<List<TransactionBudgit>> list = Future.value([]);

  late SharedPreferences sp;

  double? personal;
  double? mealPlan;
  DateTime? personalDue;
  DateTime? mealPlanDue;
  int? dailyPersonal;
  int? dailyMealPlan;

  int? dailyPersonalBudget;
  int? dailyMealPlanBudget;

  int dbWeeks = 1;

  String dbAccount = 'personal';

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
  }

  void loadDailyBudget() {
    dailyPersonalBudget = sp.getInt('dailyPersonalBudget') ?? 0;
    dailyMealPlanBudget = sp.getInt('dailyMealPlanBudget') ?? 0;
  }

  void setDailyBudget(String key, int value) {
    sp.setInt(key, value);
    if (key == 'dailyPersonalBudget') {
      dailyPersonalBudget = value;
    } else if (key == 'dailyMealPlanBudget') {
      dailyMealPlanBudget = value;
    }
  }

  void loadDaily() {
    if (daysBetween(DateTime.now(), appClosed ?? DateTime.now()) >= 1) {
      print("New, Day");

      loadDailyBudget();

      setDaily('dailyPersonal', dailyPersonalBudget ?? 0);
      setDaily('dailyMealPlan', dailyMealPlanBudget ?? 0);
    } else {
      print("Same Day");

      dailyPersonal = sp.getInt('dailyPersonal');
      dailyMealPlan = sp.getInt('dailyMealPlan');
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

  void decreaseDaily(String key, int value) {
    int tmp = 0;

    if (key == 'dailyPersonal') {
      tmp = (dailyPersonal ?? 0) - value;

      if (tmp >= 0) {
        dailyPersonal = tmp;
      } else {
        dailyPersonal = 0;
      }
    } else if (key == 'dailyMealPlan') {
      tmp = (dailyMealPlan ?? 0) - value;

      if (tmp >= 0) {
        dailyMealPlan = tmp;
      } else {
        dailyMealPlan = 0;
      }
    }

    if (tmp >= 0) {
      setDaily(key, tmp);
    } else {
      setDaily(key, 0);
    }
  }

  void calculateNewDailyBudget() {
    int dayBetween = 1;
    print("Calculate new daily\n\n");
    if ((personal ?? -1) > 0) {
      dayBetween = daysBetween(personalDue ?? DateTime.now(), DateTime.now());
      dayBetween = (dayBetween == 0 ? 1 : dayBetween);

      dailyPersonalBudget = (personal ?? 0) ~/ dayBetween;
    } else {
      dailyPersonalBudget = 0;
    }

    if ((mealPlan ?? -1) > 0) {
      dayBetween = daysBetween(mealPlanDue ?? DateTime.now(), DateTime.now());
      dayBetween = (dayBetween == 0 ? 1 : dayBetween);

      dailyMealPlanBudget = (mealPlan ?? 0) ~/ dayBetween;
    } else {
      dailyMealPlanBudget = 0;
    }

    setDailyBudget('dailyPersonalBudget', dailyPersonalBudget ?? 0);
    setDailyBudget('dailyMealPlanBudget', dailyMealPlanBudget ?? 0);

    setDaily('dailyPersonal', dailyPersonalBudget ?? 0);
    setDaily('dailyMealPlan', dailyMealPlanBudget ?? 0);
  }

  int predictNewDailyBudget(String key, double value) {
    int dayBetween = 1;
    int newBudget = 0;
    if (key == 'personal') {
      dayBetween = daysBetween(personalDue ?? DateTime.now(), DateTime.now());
      dayBetween = (dayBetween == 0 ? 1 : dayBetween);

      newBudget = ((personal ?? 0) - value) ~/ dayBetween;
    } else if (key == 'mealPlan') {
      dayBetween = daysBetween(mealPlanDue ?? DateTime.now(), DateTime.now());
      dayBetween = (dayBetween == 0 ? 1 : dayBetween);

      newBudget = ((mealPlan ?? 0) - value) ~/ dayBetween;
    }

    return newBudget < 0 ? 0 : newBudget;
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

  void decreaseBudget(String key, double value) {
    double tmp = 0;

    if (key == 'personal') {
      tmp = (personal ?? 0) - value;

      personal = tmp;
    } else if (key == 'mealPlan') {
      tmp = (mealPlan ?? 0) - value;

      mealPlan = tmp;
    }
    if (tmp < 0) {
      setBudget(key, -1);
    } else {
      setBudget(key, tmp);
    }
  }

  void setDueDate(String key, DateTime value) {
    sp.setString(key, value.toString());

    if (key == 'personalDue') {
      personalDue = value;
    } else if (key == 'mealPlanDue') {
      mealPlanDue = value;
    }
    calculateNewDailyBudget();
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
