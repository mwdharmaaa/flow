import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/account_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/receipt/receipt_scanner_modal.dart';
import 'package:flow/features/transactions/choose_category_modal.dart';
import 'package:flow/features/transactions/models/category_item_data.dart';
import 'package:flow/features/transactions/widgets/transaction_amount_display.dart';
import 'package:flow/features/transactions/widgets/transaction_calculator_keypad.dart';
import 'package:flow/features/transactions/widgets/transaction_category_chips.dart';
import 'package:flow/features/transactions/widgets/transaction_detail_rows.dart';
import 'package:flow/features/transactions/widgets/transaction_wallet_sheet.dart';

class AddTransactionDialog extends StatefulWidget {
  final List<AccountModel> accounts;
  final TransactionType initialType;
  final String? initialCategory;
  final Function(TransactionModel) onSave;
  final AppState? state;

  const AddTransactionDialog({
    super.key,
    required this.accounts,
    this.initialType = TransactionType.expense,
    this.initialCategory,
    required this.onSave,
    this.state,
  });

  static Future<void> show(
    BuildContext context, {
    required AppState state,
    TransactionType initialType = TransactionType.expense,
    String? initialCategory,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionDialog(
        accounts: state.accounts,
        initialType: initialType,
        initialCategory: initialCategory,
        state: state,
        onSave: (tx) => state.addTransaction(tx),
      ),
    );
  }

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  late TransactionType _type;
  String _amountText = '0';
  final TextEditingController _noteController = TextEditingController();

  String? _selectedAccountId;
  String? _selectedDestAccountId;
  late String _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _excludeFromTotals = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _selectedCategory = widget.initialCategory ?? _getDefaultCategory(_type);
    if (widget.accounts.isNotEmpty) {
      _selectedAccountId = widget.accounts.first.id;
      if (widget.accounts.length > 1) {
        _selectedDestAccountId = widget.accounts[1].id;
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _getDefaultCategory(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Salary';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.expense:
      default:
        return 'Groceries';
    }
  }

  List<CategoryItemData> _getCategoriesForType(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return CategoryHierarchyData.incomeCategories;
      case TransactionType.transfer:
        return CategoryHierarchyData.transferCategories;
      case TransactionType.expense:
      default:
        return CategoryHierarchyData.expenseCategories;
    }
  }

  void _onKeypadTap(String key) {
    setState(() {
      if (key == 'C') {
        _amountText = '0';
      } else if (key == '⌫') {
        if (_amountText.length <= 1) {
          _amountText = '0';
        } else {
          _amountText = _amountText.substring(0, _amountText.length - 1);
        }
      } else if (key == '00') {
        if (_amountText != '0' && !_isOperatorLast()) _amountText += '00';
      } else if (key == '000') {
        if (_amountText != '0' && !_isOperatorLast()) _amountText += '000';
      } else if (key == '0') {
        if (_amountText != '0' && !_isOperatorLast()) _amountText += '0';
      } else if (RegExp(r'^[1-9]$').hasMatch(key)) {
        if (_amountText == '0') {
          _amountText = key;
        } else {
          _amountText += key;
        }
      } else if (['+', '-', '×', '÷'].contains(key)) {
        if (_isOperatorLast()) {
          _amountText = _amountText.substring(0, _amountText.length - 1) + key;
        } else {
          _calculateResult();
          _amountText += key;
        }
      } else if (key == '=') {
        _calculateResult();
      } else if (key == 'OK') {
        _calculateResult();
        _submit();
      }
    });
  }

  bool _isOperatorLast() {
    if (_amountText.isEmpty) return false;
    final last = _amountText[_amountText.length - 1];
    return ['+', '-', '×', '÷'].contains(last);
  }

  void _calculateResult() {
    try {
      final match = RegExp(r'^(\d+(?:\.\d+)?)\s*([+\-×÷])\s*(\d+(?:\.\d+)?)$').firstMatch(_amountText);
      if (match != null) {
        final a = double.parse(match.group(1)!);
        final op = match.group(2)!;
        final b = double.parse(match.group(3)!);
        double res = a;
        if (op == '+') res = a + b;
        if (op == '-') res = a - b;
        if (op == '×') res = a * b;
        if (op == '÷') res = b != 0 ? a / b : a;

        if (res == res.roundToDouble()) {
          _amountText = res.toInt().toString();
        } else {
          _amountText = res.toStringAsFixed(2);
        }
      }
    } catch (_) {}
  }

  double _getCalculatedAmount() {
    _calculateResult();
    final clean = _amountText.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  void _submit() {
    final amount = _getCalculatedAmount();
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }
    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) {
      _openWalletPicker();
      return;
    }

    final tx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: _type,
      amount: amount,
      accountId: _selectedAccountId!,
      destinationAccountId: _type == TransactionType.transfer ? _selectedDestAccountId : null,
      category: _type == TransactionType.transfer ? 'Transfer' : _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      excludeFromTotals: _excludeFromTotals,
    );

    widget.onSave(tx);
    Navigator.of(context).pop();
  }

  void _saveAndAddAnother() {
    final amount = _getCalculatedAmount();
    if (amount <= 0) return;
    if (_selectedAccountId == null || _selectedAccountId!.isEmpty) {
      _openWalletPicker();
      return;
    }

    final tx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: _type,
      amount: amount,
      accountId: _selectedAccountId!,
      destinationAccountId: _type == TransactionType.transfer ? _selectedDestAccountId : null,
      category: _type == TransactionType.transfer ? 'Transfer' : _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      excludeFromTotals: _excludeFromTotals,
    );

    widget.onSave(tx);
    setState(() {
      _amountText = '0';
      _noteController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction saved'), duration: Duration(seconds: 1)),
    );
  }

  void _openWalletPicker() async {
    final selected = await TransactionWalletSheet.show(
      context,
      accounts: widget.accounts,
      selectedAccountId: _selectedAccountId,
      isDark: widget.state?.isDarkMode ?? false,
    );
    if (selected != null) {
      setState(() => _selectedAccountId = selected.id);
    }
  }

  void _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _openAllCategories() {
    if (widget.state == null) return;
    ChooseCategoryModal.show(
      context,
      widget.state!,
      initialType: _type,
      onCategoryPicked: (cat) => setState(() => _selectedCategory = cat),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state?.isDarkMode ?? false;
    final currentAccount = widget.accounts.where((a) => a.id == _selectedAccountId).firstOrNull;
    final categories = _getCategoriesForType(_type);
    final maxHeight = MediaQuery.of(context).size.height * 0.95;

    final sheetRadius = AppTheme.verticalTop(isDark, 28);

    return ClipRRect(
      borderRadius: sheetRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          decoration: AppTheme.liquidGlassDecoration(
            isDark: isDark,
            borderRadius: sheetRadius,
            elevated: true,
          ),
          child: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildTopBar(isDark),
            _buildSegmentedTabs(isDark),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    TransactionAmountDisplay(
                      amountText: _amountText,
                      categoryName: _selectedCategory,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 14),
                    TransactionCategoryChips(
                      selectedCategory: _selectedCategory,
                      categories: categories,
                      onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                      onAllTap: _openAllCategories,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 10),
                    TransactionDetailRows(
                      walletName: currentAccount?.name,
                      date: _selectedDate,
                      noteController: _noteController,
                      excludeFromTotals: _excludeFromTotals,
                      onChooseWalletTap: _openWalletPicker,
                      onChooseDateTap: _openDatePicker,
                      onReceiptTap: () {
                        if (widget.state != null) {
                          ReceiptScannerModal.show(context, widget.state!);
                        }
                      },
                      onExcludeChanged: (val) => setState(() => _excludeFromTotals = val),
                      isDark: isDark,
                    ),
                    _buildActionButtons(isDark),
                  ],
                ),
              ),
            ),
            TransactionCalculatorKeypad(
              onKeyTap: _onKeypadTap,
              isDark: isDark,
            ),
          ],
        ),
      ),
    ),
    ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkBgElevated : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Text(
            'Log transaction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs(bool isDark) {
    final containerBg = isDark ? AppTheme.darkBgElevated : const Color(0xFFEAF1FB);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: AppTheme.borderRadius(isDark, 24),
      ),
      child: Row(
        children: [
          _buildTabItem(TransactionType.expense, 'Expense', isDark),
          _buildTabItem(TransactionType.income, 'Income', isDark),
          _buildTabItem(TransactionType.transfer, 'Transfer', isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(TransactionType type, String label, bool isDark) {
    final isSelected = _type == type;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _type = type;
            _selectedCategory = _getDefaultCategory(type);
          });
        },
        borderRadius: AppTheme.borderRadius(isDark, 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF1E293B) : Colors.white)
                : Colors.transparent,
            borderRadius: AppTheme.borderRadius(isDark, 20),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : (isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    final hasWallet = _selectedAccountId != null && _selectedAccountId!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _saveAndAddAnother,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius(isDark, 24)),
                side: BorderSide(
                  color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFCBD5E1),
                ),
                backgroundColor: isDark ? AppTheme.darkBgElevated : Colors.white,
              ),
              child: Text(
                'Add another',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF334155),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius(isDark, 24)),
                backgroundColor: const Color(0xFF1D61E0),
                elevation: 0,
              ),
              child: Text(
                hasWallet ? 'Save' : 'Choose wallet',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
