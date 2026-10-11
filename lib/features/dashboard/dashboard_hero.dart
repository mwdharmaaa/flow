import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_prompt_bar.dart';
import 'package:flow/features/receipt/receipt_scanner_modal.dart';
import 'package:flow/features/voice/voice_assistant_modal.dart';

class DashboardHero extends StatefulWidget {
  final double monthExpense;
  final String currency;
  final DateTime currentMonth;
  final VoidCallback onAddTransaction;
  final AppState state;

  const DashboardHero({
    super.key,
    required this.monthExpense,
    required this.currency,
    required this.currentMonth,
    required this.onAddTransaction,
    required this.state,
  });

  @override
  State<DashboardHero> createState() => _DashboardHeroState();
}

class _DashboardHeroState extends State<DashboardHero> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;
    final monthName = DateFormat('MMMM', 'en_US').format(widget.currentMonth);
    final dayNum = DateTime.now().day;
    final dayLabel = DateFormat('d MMM', 'en_US').format(DateTime.now());

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  Color(0xFF121215),
                  Color(0xFF09090B),
                  Color(0xFF09090B),
                ]
              : const [
                  Color(0xFFEBF3FE),
                  Color(0xFFF3F7FD),
                  Color(0xFFFFFFFF),
                ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Navigation Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              GestureDetector(
                onTap: () => widget.state.toggleDarkMode(),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDark ? AppTheme.darkAccentPrimary : AppTheme.primary).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.waves, color: Colors.white, size: 17),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'flow',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Pills
              Row(
                children: [
                  _buildPill(dayLabel, isDark),
                  const SizedBox(width: 6),
                  _buildBadgePill('Day $dayNum', isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Greeting & Spending Header
          Center(
            child: Column(
              children: [
                Text(
                  'Hi Friend • $monthName spending',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _isHidden
                          ? '••••••'
                          : CurrencyFormatter.format(widget.monthExpense, currency: widget.currency),
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setState(() => _isHidden = !_isHidden),
                      child: Icon(
                        _isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.monthExpense == 0
                      ? 'Nothing recorded this month yet'
                      : 'Total pengeluaran tercatat bulan ini',
                  style: TextStyle(fontSize: 12, color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Clouds & Dotted Trajectory Box
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkBgElevated : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border.withValues(alpha: 0.7),
              ),
            ),
            child: Stack(
              children: [
                // Dashed guides
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(height: 1, color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border.withValues(alpha: 0.4)),
                      Container(height: 1, color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border.withValues(alpha: 0.4)),
                    ],
                  ),
                ),
                // Clouds
                Positioned(
                  top: 14,
                  left: 24,
                  child: Icon(Icons.cloud, color: Colors.white.withValues(alpha: isDark ? 0.35 : 0.9), size: 36),
                ),
                Positioned(
                  top: 28,
                  left: 90,
                  child: Icon(Icons.cloud, color: Colors.white.withValues(alpha: isDark ? 0.25 : 0.8), size: 28),
                ),
                // Center text
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Record your first expense',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "This month's chart shows up here, then gets compared\nwith last month.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: (isDark ? AppTheme.darkTextSecondary : AppTheme.subtle).withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Chat Input Prompt Bar
          ChatPromptBar(state: widget.state),
          const SizedBox(height: 14),

          // Action Pills (Receipt, Voice, +)
          Row(
            children: [
              Expanded(
                child: _buildActionPill(
                  icon: Icons.receipt_long_outlined,
                  label: 'Receipt',
                  onTap: () => ReceiptScannerModal.show(context, widget.state),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionPill(
                  icon: Icons.mic_none_rounded,
                  label: 'Voice',
                  onTap: () => VoiceAssistantModal.show(context, widget.state),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onAddTransaction,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? AppTheme.darkAccentPrimary : AppTheme.primary).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF94A3B8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBadgePill(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.darkBorderSubtle : Colors.transparent),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildActionPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkBgElevated : Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
