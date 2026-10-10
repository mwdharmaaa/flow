import 'package:flow/models/account_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/budget_model.dart';
import 'package:flow/models/debt_model.dart';
import 'package:flow/models/recurring_model.dart';

class InitialData {
  static List<AccountModel> get accounts => [
        AccountModel(
          id: 'acc_cash',
          name: 'Cash',
          type: 'cash',
          balance: 0.0,
          colorValue: 0xFF10B981,
        ),
        AccountModel(
          id: 'acc_gopay',
          name: 'GoPay',
          type: 'ewallet',
          balance: 0.0,
          colorValue: 0xFF00AED6,
        ),
        AccountModel(
          id: 'acc_jago',
          name: 'Jago',
          type: 'bank',
          balance: 0.0,
          colorValue: 0xFFFF8B00,
        ),
      ];

  static List<BudgetModel> get budgets => [];

  static List<TransactionModel> get transactions => [];

  static List<DebtModel> get debts => [];

  static List<RecurringModel> get recurring => [];
}
