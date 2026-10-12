import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/widgets/liquid_background.dart';
import 'package:flow/core/widgets/liquid_glass_container.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/analytics/widgets/analytics_daily_chart.dart';
import 'package:flow/features/analytics/widgets/analytics_six_months_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  final AppState state;

  const AnalyticsScreen({super.key, required this.state});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedTabIndex = 0; // 0 = Expenses, 1 = Income
  final DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final monthLabel = DateFormat("MMM ''yy", 'en_US').format(_currentMonth);

    final displayExpense = state.totalExpense;
    final displayIncome = state.totalIncome;

    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        isDark: isDark,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reports',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkBgElevated : AppTheme.primarySoft,
                        borderRadius: AppTheme.borderRadius(isDark, 20),
                        border: Border.all(
                          color: isDark ? AppTheme.darkBorderHighlight : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Monthly',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tab Switcher (Expenses vs Income)
                Row(
                  children: [
                    _buildTab('Expenses', 0, isDark),
                    const SizedBox(width: 24),
                    _buildTab('Income', 1, isDark),
                  ],
                ),
                const SizedBox(height: 18),

                // Total Row & Month Switcher
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTabIndex == 0 ? 'Total expenses' : 'Total income',
                      style: TextStyle(fontSize: 13, color: textSecondary),
                    ),
                    Row(
                      children: [
                        Icon(Icons.chevron_left, size: 18, color: textPrimary),
                        const SizedBox(width: 4),
                        Text(
                          monthLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 18, color: textPrimary),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Large Amount
                Text(
                  _selectedTabIndex == 0
                      ? CurrencyFormatter.format(displayExpense, currency: state.currency)
                      : CurrencyFormatter.format(displayIncome, currency: state.currency),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 4),

                // Comparison Subtitle
                Text(
                  _selectedTabIndex == 0
                      ? (displayExpense > 0
                          ? 'of ${CurrencyFormatter.format(displayIncome, currency: state.currency)} income • -${CurrencyFormatter.format(displayExpense, currency: state.currency)} left'
                          : 'of ${CurrencyFormatter.format(displayIncome, currency: state.currency)} income')
                      : (displayExpense > 0
                          ? '${CurrencyFormatter.format(displayExpense, currency: state.currency)} spent • -${CurrencyFormatter.format(displayExpense, currency: state.currency)} left'
                          : 'No expenses recorded yet'),
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
                const SizedBox(height: 24),

                // Tab Specific Content
                if (_selectedTabIndex == 0) ...[
                  // Daily Trend Bar Chart inside Liquid Glass Panel
                  LiquidGlassContainer(
                    isDark: isDark,
                    radius: 20,
                    elevated: true,
                    padding: const EdgeInsets.all(16),
                    child: AnalyticsDailyChart(
                      transactions: state.transactions,
                      currency: state.currency,
                      currentMonth: _currentMonth,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Spending Trend Section inside Liquid Glass Panel
                  LiquidGlassContainer(
                    isDark: isDark,
                    radius: 18,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spending trend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Daily, compared with last month',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text('500K', style: TextStyle(fontSize: 10, color: textSecondary)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE5ECF6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Income Tab Content inside Liquid Glass Panel
                  LiquidGlassContainer(
                    isDark: isDark,
                    radius: 18,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No income in October yet.',
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                        const SizedBox(height: 18),
                        Divider(
                          height: 1,
                          color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFF1F5F9),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Wallets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No income in October yet.',
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Last 6 Months Multi-Line Chart inside Liquid Glass Panel
                  LiquidGlassContainer(
                    isDark: isDark,
                    radius: 20,
                    elevated: true,
                    padding: const EdgeInsets.all(16),
                    child: AnalyticsSixMonthsChart(
                      incomeOct: displayIncome,
                      expenseOct: displayExpense,
                      currency: state.currency,
                      isDark: isDark,
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index, bool isDark) {
    final isSelected = _selectedTabIndex == index;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final accentColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? textPrimary : textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2.5,
            width: 70,
            color: isSelected ? accentColor : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
