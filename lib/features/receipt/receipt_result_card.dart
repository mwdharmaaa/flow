import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/receipt_model.dart';
import 'package:flow/models/account_model.dart';

class ReceiptResultCard extends StatelessWidget {
  final ReceiptData receipt;
  final String currency;
  final List<AccountModel> accounts;
  final String selectedAccountId;
  final String selectedCategory;
  final bool speakOnSave;
  final ValueChanged<String> onAccountChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onSpeakToggle;
  final VoidCallback onSave;
  final bool isDark;

  const ReceiptResultCard({
    super.key,
    required this.receipt,
    required this.currency,
    required this.accounts,
    required this.selectedAccountId,
    required this.selectedCategory,
    required this.speakOnSave,
    required this.onAccountChanged,
    required this.onCategoryChanged,
    required this.onSpeakToggle,
    required this.onSave,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Merchant & Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.merchant,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${receipt.items.length} item terdeteksi',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.format(receipt.total, currency: currency),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.expense,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          // Line Items Breakdown
          if (receipt.items.isNotEmpty)
            ...receipt.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.name}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.format(item.price * item.quantity, currency: currency),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 12),
          // Voice Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.volume_up_outlined,
                    size: 16,
                    color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Suarakan Konfirmasi (Voice Output)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Switch.adaptive(
                value: speakOnSave,
                onChanged: onSpeakToggle,
                activeColor: AppTheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Save Action Button
          ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Simpan ke Pengeluaran',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
