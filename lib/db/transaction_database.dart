import 'dart:async';

import 'package:budgit/db/model/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionDatabase {
  //global field calls constructor
  static final TransactionDatabase instance = TransactionDatabase.init();

  //sqflite database object
  static Database? _database;

  //constructor
  TransactionDatabase.init();

  //allows for a connection to the database;
  Future<Database> get database async {
    //return database if it already exists
    if (_database != null) return _database!;

    //create the database and return it
    _database = await _initDB('transactions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    //path to local storage on the device
    final dbPath = await getDatabasesPath();

    //names the file on the device
    final path = join(dbPath, filePath);

    //necessary to define the database schema
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //SQL Command to create the database
    await db.execute('''
      CREATE TABLE $TransactionTable (
        ${TransactionName.id} ${TransactionTypes.id},
        ${TransactionName.transaction_time} ${TransactionTypes.transaction_time},
        ${TransactionName.amount} ${TransactionTypes.amount},
        ${TransactionName.account} ${TransactionTypes.account}
      );
    ''');
  }

  Future<TransactionBudgit> insert(TransactionBudgit transactionBudgit) async {
    //gets the database
    final database = await instance.database;

    //inserts values into the database as a jason, which generates a unique id,
    //could be an INSERT SQL command but that would be difficult.
    final id =
        await database.insert(TransactionTable, transactionBudgit.toJson());
    return transactionBudgit.copy(id: id);
  }

  Future<TransactionBudgit?> read(int id) async {
    //gets the database
    final database = await instance.database;

    final maps = await database.query(TransactionTable,
        columns: TransactionName.values,
        where: '${TransactionName.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return TransactionBudgit.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<TransactionBudgit>> readAll() async {
    //gets the database
    final database = await instance.database;

    // await Future.delayed(Duration(seconds: 10));

    final result = await database.query(TransactionTable);

    return result.map((json) => TransactionBudgit.fromJson(json)).toList();
  }

  Future<int> update(TransactionBudgit transactionBudgit) async {
    //gets the database
    final database = await instance.database;

    return database.update(
      TransactionTable,
      transactionBudgit.toJson(),
      where: '${TransactionName.id} = ?',
      whereArgs: [transactionBudgit.id],
    );
  }

  Future<int> delete(int id) async {
    //gets the database
    final database = await instance.database;

    return database.delete(
      TransactionTable,
      where: '${TransactionName.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final database = await instance.database;
    database.close();
  }
}
