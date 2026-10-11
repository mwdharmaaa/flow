import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';

class TransactionDetailRows extends StatelessWidget {
  final String? walletName;
  final DateTime date;
  final TextEditingController noteController;
  final bool excludeFromTotals;
  final VoidCallback onChooseWalletTap;
  final VoidCallback onChooseDateTap;
  final VoidCallback onReceiptTap;
  final ValueChanged<bool> onExcludeChanged;
  final bool isDark;

  const TransactionDetailRows({
    super.key,
    required this.walletName,
    required this.date,
    required this.noteController,
    required this.excludeFromTotals,
    required this.onChooseWalletTap,
    required this.onChooseDateTap,
    required this.onReceiptTap,
    required this.onExcludeChanged,
    required this.isDark,
  });

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (isToday) {
      return 'Today, ${DateFormat('d MMM').format(dt)}';
    }
    return DateFormat('d MMM yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppTheme.darkBgElevated : Colors.white;
    final border = isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE2E8F0);
    final dividerColor = isDark ? AppTheme.darkBorderSubtle : const Color(0xFFF1F5F9);
    final labelColor = isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B);
    final valueColor = isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A);
    final iconColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Row 1: Wallet
          InkWell(
            onTap: onChooseWalletTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 20, color: iconColor),
                  const SizedBox(width: 14),
                  Text('Wallet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: labelColor)),
                  const Spacer(),
                  Text(
                    walletName ?? 'Choose wallet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: walletName != null ? valueColor : labelColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, size: 18, color: labelColor),
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // Row 2: Date
          InkWell(
            onTap: onChooseDateTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 19, color: iconColor),
                  const SizedBox(width: 14),
                  Text('Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: labelColor)),
                  const Spacer(),
                  Text(_formatDate(date), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor)),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right_rounded, size: 18, color: labelColor),
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // Row 3: Add a note... + Receipt
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 20, color: iconColor),
                const SizedBox(width: 14),
                Expanded(
                  child: TextField(
                    controller: noteController,
                    style: TextStyle(fontSize: 14, color: valueColor),
                    decoration: InputDecoration(
                      hintText: 'Add a note...',
                      hintStyle: TextStyle(fontSize: 14, color: labelColor),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onReceiptTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 18, color: iconColor),
                        const SizedBox(width: 5),
                        Text(
                          'Receipt',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: iconColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // Row 4: Exclude from totals
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.do_not_disturb_alt_outlined, size: 20, color: iconColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exclude from totals',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: valueColor),
                      ),
                      Text(
                        'Not counted in reports & budgets',
                        style: TextStyle(fontSize: 11, color: labelColor),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: excludeFromTotals,
                  onChanged: onExcludeChanged,
                  activeColor: const Color(0xFF1D61E0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
