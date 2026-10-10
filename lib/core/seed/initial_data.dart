import 'package:flow/models/account_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/budget_model.dart';
import 'package:flow/models/debt_model.dart';
import 'package:flow/models/recurring_model.dart';

class InitialData {
  static List<AccountModel> get accounts => [
        AccountModel(
          id: 'acc_1',
          name: 'Cash / Dompet',
          type: 'cash',
          balance: 750000,
          colorValue: 0xFF10B981,
        ),
        AccountModel(
          id: 'acc_2',
          name: 'Bank BCA',
          type: 'bank',
          balance: 6850000,
          colorValue: 0xFF3B82F6,
        ),
        AccountModel(
          id: 'acc_3',
          name: 'GoPay / OVO',
          type: 'ewallet',
          balance: 420000,
          colorValue: 0xFF8B5CF6,
        ),
        AccountModel(
          id: 'acc_4',
          name: 'Tabungan Darurat',
          type: 'investment',
          balance: 15000000,
          colorValue: 0xFFF59E0B,
        ),
      ];

  static List<BudgetModel> get budgets => [
        BudgetModel(
          id: 'bgt_1',
          category: 'Makanan & Minuman',
          monthlyLimit: 2500000,
          spent: 980000,
          colorValue: 0xFFF43F5E,
        ),
        BudgetModel(
          id: 'bgt_2',
          category: 'Transportasi',
          monthlyLimit: 800000,
          spent: 320000,
          colorValue: 0xFF3B82F6,
        ),
        BudgetModel(
          id: 'bgt_3',
          category: 'Hiburan & Langganan',
          monthlyLimit: 600000,
          spent: 190000,
          colorValue: 0xFF8B5CF6,
        ),
      ];

  static List<TransactionModel> get transactions => [
        TransactionModel(
          id: 'tx_1',
          type: TransactionType.income,
          amount: 12000000,
          accountId: 'acc_2',
          category: 'Gaji Bulanan',
          date: DateTime.now().subtract(const Duration(days: 3)),
          note: 'Gaji Oktober',
          createdAt: DateTime.now().millisecondsSinceEpoch - 259200000,
        ),
        TransactionModel(
          id: 'tx_2',
          type: TransactionType.expense,
          amount: 45000,
          accountId: 'acc_1',
          category: 'Makanan & Minuman',
          date: DateTime.now().subtract(const Duration(days: 1)),
          note: 'Kopi dan sarapan',
          createdAt: DateTime.now().millisecondsSinceEpoch - 86400000,
        ),
        TransactionModel(
          id: 'tx_3',
          type: TransactionType.transfer,
          amount: 500000,
          accountId: 'acc_2',
          destinationAccountId: 'acc_3',
          category: 'Transfer Saldo',
          date: DateTime.now(),
          note: 'Top up GoPay dari BCA',
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

  static List<DebtModel> get debts => [
        DebtModel(
          id: 'debt_1',
          type: 'receivable',
          personName: 'Rian Pratama',
          amount: 250000,
          remainingAmount: 250000,
          dueDate: DateTime.now().add(const Duration(days: 14)),
          note: 'Talangan beli tiket',
        ),
      ];

  static List<RecurringModel> get recurring => [
        RecurringModel(
          id: 'rec_1',
          name: 'Netflix & Spotify',
          type: 'expense',
          amount: 186000,
          accountId: 'acc_3',
          category: 'Hiburan & Langganan',
          interval: 'monthly',
          nextDate: DateTime.now().add(const Duration(days: 20)),
        ),
      ];
}
