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

  void init() async {
    db = TransactionDatabase.init();
    sp = await SharedPreferences.getInstance();

    loadTransactions();
    loadPreferences();
  }

  void loadPreferences() {
    personal = sp.getDouble('personal');
    mealPlan = sp.getDouble('mealPlan');
    dailyPersonal = sp.getInt('dailyPersonal');
    dailyMealPlan = sp.getInt('dailyMealPlan');

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

  void loadTransactions() {
    list = db.readAll(null, null);

    notifyListeners();
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
