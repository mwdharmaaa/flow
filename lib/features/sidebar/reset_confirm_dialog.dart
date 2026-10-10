import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';

class ResetConfirmDialog extends StatelessWidget {
  final AppState state;

  const ResetConfirmDialog({super.key, required this.state});

  static Future<void> show(BuildContext context, AppState state) {
    return showDialog(
      context: context,
      builder: (_) => ResetConfirmDialog(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final bg = isDark ? AppTheme.darkBgElevated : Colors.white;
    final textCol = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final borderCol = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;

    return AlertDialog(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderCol),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.expense.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restart_alt_rounded, color: AppTheme.expense, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Reset Data Keuangan?',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textCol,
            ),
          ),
        ],
      ),
      content: Text(
        'Semua transaksi, saldo dompet, anggaran, hutang, dan target tabungan akan dikembalikan ke 0 rupiah. Tindakan ini permanen.',
        style: TextStyle(
          fontSize: 13,
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: textCol,
            side: BorderSide(color: borderCol),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.expense,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onPressed: () {
            state.resetAllFinancialData();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Seluruh data keuangan berhasil direset ke 0 rupiah.'),
                backgroundColor: AppTheme.expense,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: const Text('Reset ke 0', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
