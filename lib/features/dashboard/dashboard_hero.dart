import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_prompt_bar.dart';

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
    final monthName = DateFormat('MMMM', 'en_US').format(widget.currentMonth);
    final dayNum = DateTime.now().day;
    final dayLabel = DateFormat('d MMM', 'en_US').format(DateTime.now());

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
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
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.waves, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'flow',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              // Pills
              Row(
                children: [
                  _buildPill(dayLabel),
                  const SizedBox(width: 6),
                  _buildFeedbackPill(),
                  const SizedBox(width: 6),
                  _buildBadgePill('Day $dayNum'),
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
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.subtle,
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
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => setState(() => _isHidden = !_isHidden),
                      child: Icon(
                        _isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: AppTheme.subtle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.monthExpense == 0
                      ? 'Nothing recorded this month yet'
                      : 'Total pengeluaran tercatat bulan ini',
                  style: const TextStyle(fontSize: 12, color: AppTheme.subtle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Clouds & Dotted Trajectory Box
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
            ),
            child: Stack(
              children: [
                // Dashed guides
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(height: 1, color: AppTheme.border.withValues(alpha: 0.4)),
                      Container(height: 1, color: AppTheme.border.withValues(alpha: 0.4)),
                    ],
                  ),
                ),
                // Clouds
                Positioned(
                  top: 14,
                  left: 24,
                  child: Icon(Icons.cloud, color: Colors.white.withValues(alpha: 0.9), size: 36),
                ),
                Positioned(
                  top: 28,
                  left: 90,
                  child: Icon(Icons.cloud, color: Colors.white.withValues(alpha: 0.8), size: 28),
                ),
                // Center text
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Record your first expense',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "This month's chart shows up here, then gets compared\nwith last month.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.subtle.withValues(alpha: 0.9),
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
                  onTap: widget.onAddTransaction,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionPill(
                  icon: Icons.mic_none_rounded,
                  label: 'Voice',
                  onTap: widget.onAddTransaction,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onAddTransaction,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x401D61E0),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
    );
  }

  Widget _buildFeedbackPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.rate_review_outlined, size: 12, color: AppTheme.textPrimary),
          SizedBox(width: 4),
          Text('Feedback', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildBadgePill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primary)),
    );
  }

  Widget _buildActionPill({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppTheme.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        ),
      ),
    );
  }
}
