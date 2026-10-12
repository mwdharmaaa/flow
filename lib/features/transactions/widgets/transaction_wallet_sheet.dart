import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/account_model.dart';

class TransactionWalletSheet extends StatelessWidget {
  final List<AccountModel> accounts;
  final String? selectedAccountId;
  final ValueChanged<AccountModel> onSelect;
  final bool isDark;

  const TransactionWalletSheet({
    super.key,
    required this.accounts,
    required this.selectedAccountId,
    required this.onSelect,
    required this.isDark,
  });

  static Future<AccountModel?> show(
    BuildContext context, {
    required List<AccountModel> accounts,
    required String? selectedAccountId,
    required bool isDark,
  }) {
    return showModalBottomSheet<AccountModel>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TransactionWalletSheet(
        accounts: accounts,
        selectedAccountId: selectedAccountId,
        onSelect: (acc) => Navigator.of(context).pop(acc),
        isDark: isDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTheme.darkBgBase : Colors.white;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B);

    final sheetRadius = AppTheme.verticalTop(isDark, 28);

    return ClipRRect(
      borderRadius: sheetRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: AppTheme.liquidGlassDecoration(
            isDark: isDark,
            borderRadius: sheetRadius,
            elevated: true,
          ),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Choose Wallet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: accounts.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, idx) {
                final acc = accounts[idx];
                final isSelected = acc.id == selectedAccountId;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(acc.colorValue).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Color(acc.colorValue),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    acc.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    CurrencyFormatter.format(acc.balance),
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1D61E0))
                      : null,
                  onTap: () => onSelect(acc),
                );
              },
            ),
          ),
        ],
      ),
    ),
    ),
    );
  }
}
