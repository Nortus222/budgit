final String TransactionTable = 'Test'; //TODO: change

class TransactionTypes {
  static final String id = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static final String transaction_time = 'DATETIME NOT NULL';
  static final String amount = 'DECIMAL(7, 2) NOT NULL';
  static final String account = 'VARCHAR(15) NOT NULL';
}

class TransactionName {
  static final List<String> values = [id, transaction_time, amount, account];

  static final String id = '_id';
  static final String transaction_time = 'transaction_time';
  static final String amount = 'amount';
  static final String account = 'account';
}

class TransactionBudgit {
  final int? id;
  final DateTime transaction_time;
  final double amount;
  final String account;

  const TransactionBudgit({
    this.id,
    required this.transaction_time,
    required this.amount,
    required this.account,
  });

  TransactionBudgit copy({
    int? id,
    DateTime? transaction_time,
    double? amount,
    String? account,
  }) =>
      TransactionBudgit(
        id: id ?? this.id,
        transaction_time: transaction_time ?? this.transaction_time,
        amount: amount ?? this.amount,
        account: account ?? this.account,
      );

  Map<String, Object?> toJson() => {
        TransactionName.id: id,
        TransactionName.transaction_time: transaction_time.toIso8601String(),
        TransactionName.amount: amount,
        TransactionName.account: account,
      };

  static TransactionBudgit fromJson(Map<String, Object?> json) =>
      TransactionBudgit(
        id: json[TransactionName.id] as int?,
        transaction_time:
            DateTime.parse(json[TransactionName.transaction_time] as String),
        amount: json[TransactionName.amount] as double,
        account: json[TransactionName.account] as String,
      );
}
