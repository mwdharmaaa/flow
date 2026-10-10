import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flow/core/seed/initial_data.dart';
import 'package:flow/models/account_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/budget_model.dart';
import 'package:flow/models/debt_model.dart';
import 'package:flow/models/recurring_model.dart';

class AppState extends ChangeNotifier {
  int _currentTabIndex = 0;
  String _currency = 'IDR';

  List<AccountModel> _accounts = [];
  List<TransactionModel> _transactions = [];
  List<BudgetModel> _budgets = [];
  List<DebtModel> _debts = [];
  List<RecurringModel> _recurring = [];

  int get currentTabIndex => _currentTabIndex;
  String get currency => _currency;

  List<AccountModel> get accounts => _accounts;
  List<TransactionModel> get transactions => _transactions;
  List<BudgetModel> get budgets => _budgets;
  List<DebtModel> get debts => _debts;
  List<RecurringModel> get recurring => _recurring;

  double get totalBalance => _accounts
      .where((a) => !a.isExcludedFromTotal)
      .fold(0.0, (sum, a) => sum + a.balance);

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  AppState() {
    _loadState();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setCurrency(String curr) {
    _currency = curr;
    _saveState();
    notifyListeners();
  }

  void addTransaction(TransactionModel tx) {
    _transactions.insert(0, tx);

    // Update balances
    final accIndex = _accounts.indexWhere((a) => a.id == tx.accountId);
    if (accIndex != -1) {
      final acc = _accounts[accIndex];
      if (tx.type == TransactionType.expense || tx.type == TransactionType.transfer) {
        _accounts[accIndex] = acc.copyWith(balance: acc.balance - tx.amount);
      } else if (tx.type == TransactionType.income) {
        _accounts[accIndex] = acc.copyWith(balance: acc.balance + tx.amount);
      }
    }

    if (tx.type == TransactionType.transfer && tx.destinationAccountId != null) {
      final destIndex = _accounts.indexWhere((a) => a.id == tx.destinationAccountId);
      if (destIndex != -1) {
        final dest = _accounts[destIndex];
        _accounts[destIndex] = dest.copyWith(balance: dest.balance + tx.amount);
      }
    }

    _saveState();
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((tx) => tx.id == id);
    _saveState();
    notifyListeners();
  }

  void addAccount(AccountModel acc) {
    _accounts.add(acc);
    _saveState();
    notifyListeners();
  }

  void addBudget(BudgetModel bgt) {
    _budgets.add(bgt);
    _saveState();
    notifyListeners();
  }

  void addDebt(DebtModel debt) {
    _debts.insert(0, debt);
    _saveState();
    notifyListeners();
  }

  void settleDebt(String id) {
    final idx = _debts.indexWhere((d) => d.id == id);
    if (idx != -1) {
      _debts[idx] = _debts[idx].copyWith(isSettled: true, remainingAmount: 0);
      _saveState();
      notifyListeners();
    }
  }

  void addRecurring(RecurringModel rec) {
    _recurring.add(rec);
    _saveState();
    notifyListeners();
  }

  void toggleRecurring(String id) {
    final idx = _recurring.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _recurring[idx] = _recurring[idx].copyWith(isActive: !_recurring[idx].isActive);
      _saveState();
      notifyListeners();
    }
  }

  void resetToDefaults() {
    _accounts = InitialData.accounts;
    _transactions = InitialData.transactions;
    _budgets = InitialData.budgets;
    _debts = InitialData.debts;
    _recurring = InitialData.recurring;
    _saveState();
    notifyListeners();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accJson = prefs.getString('flow_accounts');
      if (accJson != null) {
        final List list = jsonDecode(accJson);
        _accounts = list.map((e) => AccountModel.fromJson(e)).toList();
      } else {
        _accounts = InitialData.accounts;
      }

      final txJson = prefs.getString('flow_transactions');
      if (txJson != null) {
        final List list = jsonDecode(txJson);
        _transactions = list.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        _transactions = InitialData.transactions;
      }

      final bgtJson = prefs.getString('flow_budgets');
      if (bgtJson != null) {
        final List list = jsonDecode(bgtJson);
        _budgets = list.map((e) => BudgetModel.fromJson(e)).toList();
      } else {
        _budgets = InitialData.budgets;
      }

      final debtJson = prefs.getString('flow_debts');
      if (debtJson != null) {
        final List list = jsonDecode(debtJson);
        _debts = list.map((e) => DebtModel.fromJson(e)).toList();
      } else {
        _debts = InitialData.debts;
      }

      final recJson = prefs.getString('flow_recurring');
      if (recJson != null) {
        final List list = jsonDecode(recJson);
        _recurring = list.map((e) => RecurringModel.fromJson(e)).toList();
      } else {
        _recurring = InitialData.recurring;
      }

      _currency = prefs.getString('flow_currency') ?? 'IDR';
      notifyListeners();
    } catch (_) {
      resetToDefaults();
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('flow_accounts', jsonEncode(_accounts.map((e) => e.toJson()).toList()));
      await prefs.setString('flow_transactions', jsonEncode(_transactions.map((e) => e.toJson()).toList()));
      await prefs.setString('flow_budgets', jsonEncode(_budgets.map((e) => e.toJson()).toList()));
      await prefs.setString('flow_debts', jsonEncode(_debts.map((e) => e.toJson()).toList()));
      await prefs.setString('flow_recurring', jsonEncode(_recurring.map((e) => e.toJson()).toList()));
      await prefs.setString('flow_currency', _currency);
    } catch (_) {}
  }
}
