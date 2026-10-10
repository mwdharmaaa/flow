import 'package:flow/models/account_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/budget_model.dart';
import 'package:flow/models/debt_model.dart';
import 'package:flow/models/recurring_model.dart';

class InitialData {
  static List<AccountModel> get accounts => [
        AccountModel(
          id: 'acc_default',
          name: 'Dompet Utama',
          type: 'cash',
          balance: 0.0,
          colorValue: 0xFF3B82F6,
        ),
      ];

  static List<BudgetModel> get budgets => [];

  static List<TransactionModel> get transactions => [];

  static List<DebtModel> get debts => [];

  static List<RecurringModel> get recurring => [];
}
