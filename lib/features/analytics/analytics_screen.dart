import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
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

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reports',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppTheme.primarySoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tab Switcher (Expenses vs Income)
              Row(
                children: [
                  _buildTab('Expenses', 0),
                  const SizedBox(width: 24),
                  _buildTab('Income', 1),
                ],
              ),
              const SizedBox(height: 18),

              // Total Row & Month Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTabIndex == 0 ? 'Total expenses' : 'Total income',
                    style: const TextStyle(fontSize: 13, color: AppTheme.subtle),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.chevron_left, size: 18, color: AppTheme.textPrimary),
                      const SizedBox(width: 4),
                      Text(
                        monthLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 18, color: AppTheme.textPrimary),
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
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
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
                style: const TextStyle(fontSize: 12, color: AppTheme.subtle),
              ),
              const SizedBox(height: 28),

              // Tab Specific Content
              if (_selectedTabIndex == 0) ...[
                // Daily Trend Bar Chart (photo 501)
                AnalyticsDailyChart(
                  transactions: state.transactions,
                  currency: state.currency,
                  currentMonth: _currentMonth,
                ),
                const SizedBox(height: 36),

                // Spending Trend Section
                const Text(
                  'Spending trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Daily, compared with last month',
                  style: TextStyle(fontSize: 12, color: AppTheme.subtle),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('500K', style: TextStyle(fontSize: 10, color: AppTheme.subtle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(height: 1, color: const Color(0xFFE5ECF6)),
                    ),
                  ],
                ),
              ] else ...[
                // Income Tab Content (photo 503)
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'No income in October yet.',
                  style: TextStyle(fontSize: 13, color: AppTheme.subtle),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Wallets',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'No income in October yet.',
                  style: TextStyle(fontSize: 13, color: AppTheme.subtle),
                ),
                const SizedBox(height: 32),

                // Last 6 Months Multi-Line Chart
                AnalyticsSixMonthsChart(
                  incomeOct: displayIncome,
                  expenseOct: displayExpense,
                  currency: state.currency,
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
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
              color: isSelected ? AppTheme.textPrimary : AppTheme.subtle,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2.5,
            width: 70,
            color: isSelected ? AppTheme.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
