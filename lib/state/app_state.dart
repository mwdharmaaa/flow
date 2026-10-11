import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flow/core/seed/initial_data.dart';
import 'package:flow/models/account_model.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/budget_model.dart';
import 'package:flow/models/debt_model.dart';
import 'package:flow/models/recurring_model.dart';
import 'package:flow/models/goal_model.dart';

class AppState extends ChangeNotifier {
  int _currentTabIndex = 0;
  String _currency = 'IDR';
  bool _isDarkMode = false;
  final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

  Timer? _saveDebounceTimer;
  SharedPreferences? _cachedPrefs;

  List<AccountModel> _accounts = [];
  List<TransactionModel> _transactions = [];
  List<BudgetModel> _budgets = [];
  List<DebtModel> _debts = [];
  List<RecurringModel> _recurring = [];
  List<GoalModel> _goals = [];

  int get currentTabIndex => _currentTabIndex;
  String get currency => _currency;
  bool get isDarkMode => _isDarkMode;

  List<AccountModel> get accounts => _accounts;
  List<TransactionModel> get transactions => _transactions;
  List<BudgetModel> get budgets => _budgets;
  List<DebtModel> get debts => _debts;
  List<RecurringModel> get recurring => _recurring;
  List<GoalModel> get goals => _goals;

  List<TransactionModel> _lastDeletedBackup = [];
  List<TransactionModel> get lastDeletedBackup => _lastDeletedBackup;
  int get restorableCount => _lastDeletedBackup.isNotEmpty
      ? _lastDeletedBackup.length
      : (_transactions.isEmpty ? InitialData.transactions.length : 0);

  double get totalBalance => _accounts
      .where((a) => !a.isExcludedFromTotal)
      .fold(0.0, (sum, a) => sum + a.balance);

  double get totalIncome => _transactions
      .where((t) => t.type == TransactionType.income && !t.excludeFromTotals)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.type == TransactionType.expense && !t.excludeFromTotals)
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

  void toggleDarkMode([bool? value]) {
    _isDarkMode = value ?? !_isDarkMode;
    darkModeNotifier.value = _isDarkMode;
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
    final txIndex = _transactions.indexWhere((tx) => tx.id == id);
    if (txIndex != -1) {
      final tx = _transactions[txIndex];
      // Revert account balance
      final accIndex = _accounts.indexWhere((a) => a.id == tx.accountId);
      if (accIndex != -1) {
        final acc = _accounts[accIndex];
        if (tx.type == TransactionType.expense || tx.type == TransactionType.transfer) {
          _accounts[accIndex] = acc.copyWith(balance: acc.balance + tx.amount);
        } else if (tx.type == TransactionType.income) {
          _accounts[accIndex] = acc.copyWith(balance: acc.balance - tx.amount);
        }
      }

      if (tx.type == TransactionType.transfer && tx.destinationAccountId != null) {
        final destIndex = _accounts.indexWhere((a) => a.id == tx.destinationAccountId);
        if (destIndex != -1) {
          final dest = _accounts[destIndex];
          _accounts[destIndex] = dest.copyWith(balance: dest.balance - tx.amount);
        }
      }

      _lastDeletedBackup = [tx];
      _transactions.removeAt(txIndex);
      _saveState();
      notifyListeners();
    }
  }

  int clearAllTransactions({bool revertBalances = true}) {
    final count = _transactions.length;
    _lastDeletedBackup = List.from(_transactions);

    if (revertBalances) {
      for (final tx in _transactions) {
        final accIndex = _accounts.indexWhere((a) => a.id == tx.accountId);
        if (accIndex != -1) {
          final acc = _accounts[accIndex];
          if (tx.type == TransactionType.expense || tx.type == TransactionType.transfer) {
            _accounts[accIndex] = acc.copyWith(balance: acc.balance + tx.amount);
          } else if (tx.type == TransactionType.income) {
            _accounts[accIndex] = acc.copyWith(balance: acc.balance - tx.amount);
          }
        }

        if (tx.type == TransactionType.transfer && tx.destinationAccountId != null) {
          final destIndex = _accounts.indexWhere((a) => a.id == tx.destinationAccountId);
          if (destIndex != -1) {
            final dest = _accounts[destIndex];
            _accounts[destIndex] = dest.copyWith(balance: dest.balance - tx.amount);
          }
        }
      }
    }
    _transactions.clear();
    _saveState();
    notifyListeners();
    return count;
  }

  int deleteTransactionsByDate(DateTime targetDate, {bool revertBalances = true}) {
    final toRemove = _transactions.where((tx) =>
      tx.date.year == targetDate.year &&
      tx.date.month == targetDate.month &&
      tx.date.day == targetDate.day
    ).toList();

    if (toRemove.isEmpty) return 0;
    _lastDeletedBackup = List.from(toRemove);

    if (revertBalances) {
      for (final tx in toRemove) {
        final accIndex = _accounts.indexWhere((a) => a.id == tx.accountId);
        if (accIndex != -1) {
          final acc = _accounts[accIndex];
          if (tx.type == TransactionType.expense || tx.type == TransactionType.transfer) {
            _accounts[accIndex] = acc.copyWith(balance: acc.balance + tx.amount);
          } else if (tx.type == TransactionType.income) {
            _accounts[accIndex] = acc.copyWith(balance: acc.balance - tx.amount);
          }
        }

        if (tx.type == TransactionType.transfer && tx.destinationAccountId != null) {
          final destIndex = _accounts.indexWhere((a) => a.id == tx.destinationAccountId);
          if (destIndex != -1) {
            final dest = _accounts[destIndex];
            _accounts[destIndex] = dest.copyWith(balance: dest.balance - tx.amount);
          }
        }
      }
    }

    _transactions.removeWhere((tx) =>
      tx.date.year == targetDate.year &&
      tx.date.month == targetDate.month &&
      tx.date.day == targetDate.day
    );

    _saveState();
    notifyListeners();
    return toRemove.length;
  }

  int restoreLastDeletedTransactions({bool adjustBalances = true}) {
    List<TransactionModel> toRestore = [];
    if (_lastDeletedBackup.isNotEmpty) {
      toRestore = List.from(_lastDeletedBackup);
      _lastDeletedBackup.clear();
    } else if (_transactions.isEmpty) {
      toRestore = List.from(InitialData.transactions);
    }

    if (toRestore.isEmpty) return 0;

    final existingIds = _transactions.map((t) => t.id).toSet();
    final uniqueToRestore = toRestore.where((t) => !existingIds.contains(t.id)).toList();
    if (uniqueToRestore.isEmpty) return 0;

    if (adjustBalances) {
      for (final tx in uniqueToRestore) {
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
      }
    }

    _transactions.insertAll(0, uniqueToRestore);
    _saveState();
    notifyListeners();
    return uniqueToRestore.length;
  }

  void addAccount(AccountModel acc) {
    _accounts.add(acc);
    _saveState();
    notifyListeners();
  }

  void adjustAccountBalance(String id, double newBalance) {
    final idx = _accounts.indexWhere((a) => a.id == id);
    if (idx != -1) {
      _accounts[idx] = _accounts[idx].copyWith(balance: newBalance);
      _saveState();
      notifyListeners();
    }
  }

  void deleteAccount(String id) {
    _accounts.removeWhere((a) => a.id == id);
    _saveState();
    notifyListeners();
  }

  String resolveOrCreateAccountId(String? walletName) {
    if (walletName == null || walletName.trim().isEmpty) {
      return _accounts.isNotEmpty ? _accounts.first.id : 'acc_cash';
    }
    final normalized = walletName.trim().toLowerCase();
    final existing = _accounts.cast<AccountModel?>().firstWhere(
      (a) => a?.name.trim().toLowerCase() == normalized,
      orElse: () => null,
    );
    if (existing != null) {
      return existing.id;
    }
    final newAcc = AccountModel(
      id: 'acc_${DateTime.now().millisecondsSinceEpoch}_${walletName.hashCode.abs() % 1000}',
      name: walletName.trim(),
      type: 'Wallet',
      balance: 0.0,
      colorValue: 0xFF1D61E0,
    );
    addAccount(newAcc);
    return newAcc.id;
  }

  void addBudget(BudgetModel bgt) {
    _budgets.add(bgt);
    _saveState();
    notifyListeners();
  }

  void addOrUpdateBudget(String category, double amount) {
    final idx = _budgets.indexWhere((b) => b.category.toLowerCase() == category.toLowerCase());
    if (idx != -1) {
      final existing = _budgets[idx];
      _budgets[idx] = existing.copyWith(monthlyLimit: existing.monthlyLimit + amount);
    } else {
      _budgets.add(BudgetModel(
        id: 'bgt_${DateTime.now().millisecondsSinceEpoch}',
        category: category,
        monthlyLimit: amount,
        spent: 0.0,
        colorValue: 0xFF1D61E0,
      ));
    }
    _saveState();
    notifyListeners();
  }

  void deleteBudget(String id) {
    _budgets.removeWhere((b) => b.id == id);
    _saveState();
    notifyListeners();
  }

  void resetAllFinancialData() {
    _transactions = [];
    _budgets = [];
    _debts = [];
    _recurring = [];
    _goals = [];
    _accounts = _accounts.map((a) => a.copyWith(balance: 0.0)).toList();
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

  void addGoal(GoalModel goal) {
    _goals.add(goal);
    _saveState();
    notifyListeners();
  }

  void updateGoalSavedAmount(String id, double deltaAmount) {
    final idx = _goals.indexWhere((g) => g.id == id);
    if (idx != -1) {
      final updated = (_goals[idx].savedAmount + deltaAmount).clamp(0.0, double.infinity);
      _goals[idx] = _goals[idx].copyWith(savedAmount: updated);
      _saveState();
      notifyListeners();
    }
  }

  void deleteGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    _saveState();
    notifyListeners();
  }

  void resetToDefaults() {
    _accounts = InitialData.accounts;
    _transactions = InitialData.transactions;
    _budgets = InitialData.budgets;
    _debts = InitialData.debts;
    _recurring = InitialData.recurring;
    _goals = [];
    _saveState();
    notifyListeners();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('flow_v3_zero_reset')) {
        await prefs.clear();
        await prefs.setBool('flow_v3_zero_reset', true);
        resetToDefaults();
        return;
      }
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

      final goalJson = prefs.getString('flow_goals');
      if (goalJson != null) {
        final List list = jsonDecode(goalJson);
        _goals = list.map((e) => GoalModel.fromJson(e)).toList();
      } else {
        _goals = [];
      }

      _currency = prefs.getString('flow_currency') ?? 'IDR';
      _isDarkMode = prefs.getBool('flow_dark_mode') ?? false;
      darkModeNotifier.value = _isDarkMode;
      notifyListeners();
    } catch (_) {
      resetToDefaults();
    }
  }

  void _saveState() {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(const Duration(milliseconds: 250), _persistState);
  }

  Future<void> _persistState() async {
    try {
      final prefs = _cachedPrefs ??= await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('flow_accounts', jsonEncode(_accounts.map((e) => e.toJson()).toList())),
        prefs.setString('flow_transactions', jsonEncode(_transactions.map((e) => e.toJson()).toList())),
        prefs.setString('flow_budgets', jsonEncode(_budgets.map((e) => e.toJson()).toList())),
        prefs.setString('flow_debts', jsonEncode(_debts.map((e) => e.toJson()).toList())),
        prefs.setString('flow_recurring', jsonEncode(_recurring.map((e) => e.toJson()).toList())),
        prefs.setString('flow_goals', jsonEncode(_goals.map((e) => e.toJson()).toList())),
        prefs.setString('flow_currency', _currency),
        prefs.setBool('flow_dark_mode', _isDarkMode),
      ]);
    } catch (_) {}
  }
}
