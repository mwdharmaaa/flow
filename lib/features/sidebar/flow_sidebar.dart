import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/sidebar/reset_confirm_dialog.dart';

class FlowSidebar extends StatelessWidget {
  final AppState state;
  final VoidCallback? onClose;

  const FlowSidebar({
    super.key,
    required this.state,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final bg = isDark ? AppTheme.darkBgSurface : Colors.white;
    final textCol = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final subtleCol = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final borderCol = isDark ? AppTheme.darkBorderSubtle : AppTheme.border;
    final activeBg = isDark ? AppTheme.darkAccentSubtle : AppTheme.primarySoft;
    final activeColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;

    return Drawer(
      backgroundColor: bg,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.waves, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'flow',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: textCol,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? AppTheme.darkBgElevated : AppTheme.primarySoft,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderCol),
                            ),
                            child: Text(
                              'v1.0.0',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: activeColor),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Personal Finance Tracker',
                        style: TextStyle(fontSize: 11, color: subtleCol),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: subtleCol, size: 20),
                    onPressed: () => onClose != null ? onClose!() : Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderCol),

            // Content List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                children: [
                  // Theme Section
                  _buildSectionLabel('TAMPILAN & TEMA', subtleCol),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBgElevated : const Color(0xFFF6F8FB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderCol),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                          size: 20,
                          color: activeColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dark Mode',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textCol),
                              ),
                              Text(
                                isDark ? 'Layoutcraft (#09090b)' : 'Moni Light Theme',
                                style: TextStyle(fontSize: 11, color: subtleCol),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isDark,
                          activeColor: activeColor,
                          onChanged: (_) => state.toggleDarkMode(),
                        ),
                      ],
                    ),
                  ),

                  // Navigation Section
                  _buildSectionLabel('NAVIGASI UTAMA', subtleCol),
                  _buildNavTile(
                    icon: Icons.home_rounded,
                    label: 'Beranda (Home)',
                    index: 0,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),
                  _buildNavTile(
                    icon: Icons.bar_chart_rounded,
                    label: 'Laporan & Analitik',
                    index: 1,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),
                  _buildNavTile(
                    icon: Icons.pie_chart_rounded,
                    label: 'Anggaran Bulanan',
                    index: 2,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),
                  _buildNavTile(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Dompet & Rekening',
                    index: 3,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),
                  _buildNavTile(
                    icon: Icons.handshake_outlined,
                    label: 'Hutang & Piutang',
                    index: 4,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),
                  _buildNavTile(
                    icon: Icons.autorenew_rounded,
                    label: 'Tagihan Rutin',
                    index: 5,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),
                  _buildNavTile(
                    icon: Icons.flag_outlined,
                    label: 'Target Tabungan',
                    index: 6,
                    context: context,
                    activeBg: activeBg,
                    activeColor: activeColor,
                    textCol: textCol,
                  ),

                  const SizedBox(height: 16),
                  _buildSectionLabel('MANAJEMEN DATA', subtleCol),

                  // Currency Selection
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBgElevated : const Color(0xFFF6F8FB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderCol),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.currency_exchange_rounded, size: 18, color: activeColor),
                            const SizedBox(width: 10),
                            Text(
                              'Mata Uang',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textCol),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: state.currency,
                          underline: const SizedBox(),
                          dropdownColor: isDark ? AppTheme.darkBgElevated : Colors.white,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: activeColor),
                          items: const [
                            DropdownMenuItem(value: 'IDR', child: Text('IDR (Rp)')),
                            DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                            DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                            DropdownMenuItem(value: 'SGD', child: Text('SGD (S\$)')),
                          ],
                          onChanged: (val) {
                            if (val != null) state.setCurrency(val);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Reset Financial Data Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      ResetConfirmDialog.show(context, state);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.expense.withValues(alpha: isDark ? 0.15 : 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.expense.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.restart_alt_rounded, color: AppTheme.expense, size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reset Data Keuangan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.expense,
                                  ),
                                ),
                                Text(
                                  'Kembalikan semua saldo ke 0 IDR',
                                  style: TextStyle(fontSize: 11, color: AppTheme.expense),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: AppTheme.expense, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: borderCol))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Layoutcraft Benchmark', style: TextStyle(fontSize: 10, color: subtleCol)),
                  Text('by @mwdhrmaaa', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: subtleCol)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, bottom: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
    required Color activeBg,
    required Color activeColor,
    required Color textCol,
  }) {
    final isSelected = state.currentTabIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? activeBg : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Icon(icon, size: 20, color: isSelected ? activeColor : textCol),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? activeColor : textCol,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          state.setTabIndex(index);
        },
      ),
    );
  }
}
