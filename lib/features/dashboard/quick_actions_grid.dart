import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class QuickActionsGrid extends StatelessWidget {
  final VoidCallback onTransfer;
  final VoidCallback onAnalytics;
  final VoidCallback onDebts;
  final VoidCallback onRecurring;

  const QuickActionsGrid({
    super.key,
    required this.onTransfer,
    required this.onAnalytics,
    required this.onDebts,
    required this.onRecurring,
  });

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AKSI CEPAT & NAVIGASI PRO',
          style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildActionButton(
              icon: Icons.swap_horiz,
              label: 'Transfer',
              color: AppTheme.transfer,
              onTap: onTransfer,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.bar_chart,
              label: 'Analitik',
              color: AppTheme.primary,
              onTap: onAnalytics,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.handshake_outlined,
              label: 'Hutang',
              color: AppTheme.warning,
              onTap: onDebts,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.update,
              label: 'Rutin',
              color: AppTheme.income,
              onTap: onRecurring,
            ),
          ],
        ),
      ],
    );
  }
}
