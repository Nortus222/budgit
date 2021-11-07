// ignore_for_file: file_names

import 'package:budgit/db/model/transaction.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:budgit/db/transaction_database.dart';

class AppStateModel extends foundation.ChangeNotifier {
  final db = TransactionDatabase.init();

  late Future<List<TransactionBudgit>> list;

  void loadTransactions() {
    list = db.readAll();

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
