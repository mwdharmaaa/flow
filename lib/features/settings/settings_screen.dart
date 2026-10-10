import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenAnalytics;
  final VoidCallback onOpenDebts;
  final VoidCallback onOpenRecurring;
  final VoidCallback onOpenGoals;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onOpenAnalytics,
    required this.onOpenDebts,
    required this.onOpenRecurring,
    required this.onOpenGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('FITUR & LAPORAN', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildMenuTile(Icons.bar_chart, 'Analitik & Grafik Arus Kas', onOpenAnalytics),
                  const Divider(color: AppTheme.border, height: 1),
                  _buildMenuTile(Icons.savings_outlined, 'Target Keuangan & Celengan', onOpenGoals),
                  const Divider(color: AppTheme.border, height: 1),
                  _buildMenuTile(Icons.handshake_outlined, 'Catatan Hutang & Piutang', onOpenDebts),
                  const Divider(color: AppTheme.border, height: 1),
                  _buildMenuTile(Icons.autorenew, 'Langganan & Tagihan Rutin', onOpenRecurring),
                  const Divider(color: AppTheme.border, height: 1),
                  _buildMenuTile(Icons.file_download_outlined, 'Ekspor Transaksi CSV (Free)', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data transaksi diekspor secara lokal')),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MATA UANG UTAMA', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: ['IDR', 'USD', 'EUR'].map((c) {
                      final isSelected = state.currency == c;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => state.setCurrency(c),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary.withValues(alpha: 0.2) : AppTheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
                            ),
                            alignment: Alignment.center,
                            child: Text(c, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppTheme.primary : Colors.white)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.shield_outlined, size: 28, color: AppTheme.income),
                  const SizedBox(height: 8),
                  const Text('Flow Flutter v1.0.0', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('100% Offline Lokal • Tanpa Login • Bebas Paywall', style: TextStyle(color: AppTheme.subtle, fontSize: 11)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => state.resetToDefaults(),
                    icon: const Icon(Icons.restart_alt, size: 16, color: AppTheme.expense),
                    label: const Text('Reset Data ke Bawaan', style: TextStyle(color: AppTheme.expense, fontSize: 11)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.expense)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppTheme.subtle),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }
}
