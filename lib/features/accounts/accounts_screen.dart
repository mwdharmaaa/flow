import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/accounts/add_account_dialog.dart';
import 'package:flow/features/accounts/adjust_balance_dialog.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wallets',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Net Balance', style: TextStyle(fontSize: 11, color: AppTheme.subtle)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(state.totalBalance, currency: state.currency),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
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
                        backgroundColor: AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'WALLETS & ACCOUNTS (${state.accounts.length})',
                style: const TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
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
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(acc.colorValue).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_getAccountIcon(acc.type), size: 20, color: Color(acc.colorValue)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(acc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                                const SizedBox(height: 2),
                                Text(acc.type.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppTheme.subtle)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                CurrencyFormatter.format(acc.balance, currency: state.currency),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                              ),
                              const SizedBox(height: 4),
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
                                    color: AppTheme.primarySoft,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Adjust',
                                    style: TextStyle(fontSize: 10, color: AppTheme.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
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
    );
  }
}
