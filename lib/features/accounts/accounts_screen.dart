import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/widgets/liquid_background.dart';
import 'package:flow/core/widgets/liquid_glass_container.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/accounts/add_account_dialog.dart';
import 'package:flow/features/accounts/adjust_balance_dialog.dart';
import 'package:flow/features/accounts/delete_account_dialog.dart';

class AccountsScreen extends StatelessWidget {
  final AppState state;

  const AccountsScreen({super.key, required this.state});

  IconData _getAccountIcon(String type) {
    switch (type) {
      case 'bank':
        return Icons.account_balance_outlined;
      case 'ewallet':
        return Icons.phone_android_outlined;
      case 'investment':
        return Icons.savings_outlined;
      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  void _confirmDeleteAccount(BuildContext context, dynamic acc) {
    if (state.accounts.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete the only wallet. At least one wallet is required.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(
        account: acc,
        currency: state.currency,
        onConfirm: () {
          final ok = state.deleteAccount(acc.id);
          if (ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Wallet "${acc.name}" deleted'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSubtle = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final cardBg = isDark ? AppTheme.darkBgElevated : Colors.white;
    final borderSubtle = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBgBase : AppTheme.background,
      body: LiquidBackground(
        isDark: isDark,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallets',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 18),
                LiquidGlassContainer(
                  isDark: isDark,
                  width: double.infinity,
                  radius: 20,
                  elevated: true,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Net Balance', style: TextStyle(fontSize: 11, color: textSubtle)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(state.totalBalance, currency: state.currency),
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimary),
                        ),
                        const SizedBox(height: 4),
                        const Text('100% Offline Local', style: TextStyle(fontSize: 11, color: AppTheme.income, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddAccountDialog(onSave: (acc) => state.addAccount(acc)),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius(isDark, 12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'WALLETS & ACCOUNTS (${state.accounts.length})',
                style: TextStyle(fontSize: 11, color: textSubtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 110),
                  physics: const BouncingScrollPhysics(),
                  cacheExtent: 300,
                  itemCount: state.accounts.length,
                  itemBuilder: (_, idx) {
                    final acc = state.accounts[idx];
                    return LiquidGlassContainer(
                      isDark: isDark,
                      radius: 18,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(acc.colorValue).withValues(alpha: 0.12),
                              borderRadius: AppTheme.borderRadius(isDark, 12),
                            ),
                            child: Icon(_getAccountIcon(acc.type), size: 20, color: Color(acc.colorValue)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(acc.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                                const SizedBox(height: 2),
                                Text(acc.type.toUpperCase(), style: TextStyle(fontSize: 10, color: textSubtle)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                CurrencyFormatter.format(acc.balance, currency: state.currency),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AdjustBalanceDialog(
                                          account: acc,
                                          currency: state.currency,
                                          onSave: (val) => state.adjustAccountBalance(acc.id, val),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppTheme.darkBgSurface : AppTheme.primarySoft,
                                        borderRadius: AppTheme.borderRadius(isDark, 6),
                                      ),
                                      child: Text(
                                        'Adjust',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => _confirmDeleteAccount(context, acc),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0x28EF4444) : const Color(0xFFFEE2E2),
                                        borderRadius: AppTheme.borderRadius(isDark, 6),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 13,
                                        color: AppTheme.expense,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}
