import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/budgets/widgets/budget_circular_ring.dart';
import 'package:flow/features/budgets/widgets/budget_category_tile.dart';
import 'package:flow/features/budgets/add_budget_dialog.dart';
import 'package:flow/models/budget_model.dart';

class BudgetsScreen extends StatefulWidget {
  final AppState state;

  const BudgetsScreen({super.key, required this.state});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  void _openAddOrEditBudget(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddBudgetDialog(onSave: (bgt) => widget.state.addBudget(bgt)),
    );
  }

  void _confirmDeleteBudget(BuildContext context, BudgetModel budget) {
    final isDark = widget.state.isDarkMode;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppTheme.darkBgElevated : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Budget',
          style: TextStyle(
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the budget for ${budget.category} (${CurrencyFormatter.format(budget.monthlyLimit, currency: widget.state.currency)})?',
          style: TextStyle(
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.state.deleteBudget(budget.id);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.expense,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final monthName = DateFormat('MMMM yyyy', 'en_US').format(_currentMonth);

    final totalLimit = state.budgets.fold(0.0, (sum, b) => sum + b.monthlyLimit);
    final totalSpent = state.budgets.fold(0.0, (sum, b) => sum + b.spent);

    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBgBase : AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openAddOrEditBudget(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkBgElevated : AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? AppTheme.darkBorderSubtle : Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            state.budgets.isEmpty ? Icons.add : Icons.edit_outlined,
                            size: 14,
                            color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            state.budgets.isEmpty ? 'New' : 'Edit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (state.budgets.isEmpty) ...[
                // Empty state matching photo_6219746036780044497_y.jpg
                _buildEmptyState(context),
              ] else ...[
                // Active state matching photo_6219746036780044502_y.jpg
                // Month Navigator (< October 2026 >)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chevron_left, size: 20, color: textPrimary),
                    const SizedBox(width: 8),
                    Text(
                      monthName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, size: 20, color: textPrimary),
                  ],
                ),
                const SizedBox(height: 28),

                // Circular Progress Ring
                BudgetCircularRing(
                  spent: totalSpent,
                  limit: totalLimit,
                  currency: state.currency,
                ),
                const SizedBox(height: 36),

                // By Category Section
                Text(
                  'By category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                ...state.budgets.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: BudgetCategoryTile(
                        category: b.category,
                        spent: b.spent,
                        limit: b.monthlyLimit,
                        currency: state.currency,
                        icon: Icons.restaurant_rounded,
                        iconBgColor: Color(b.colorValue),
                        isDark: isDark,
                        onDelete: () => _confirmDeleteBudget(context, b),
                      ),
                    )),
                const SizedBox(height: 36),

                // Last 6 Months Section
                const Text(
                  'Last 6 months',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: AppTheme.subtle),
                    children: [
                      TextSpan(
                        text: 'Oct (in progress) • ${CurrencyFormatter.format(totalSpent, currency: state.currency)} • ',
                      ),
                      TextSpan(
                        text: '${CurrencyFormatter.format((totalLimit - totalSpent).clamp(0.0, double.infinity), currency: state.currency)} left',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Dotted Budget Guide Line
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'budget ${CurrencyFormatter.format(totalLimit, currency: state.currency)}',
                      style: const TextStyle(fontSize: 10, color: AppTheme.subtle),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 1,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFC8D7ED),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        // Skeleton Bar Illustration
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _buildSkeletonRow(130, 70),
              const SizedBox(height: 12),
              _buildFullSkeletonBar(),
              const SizedBox(height: 18),
              _buildSkeletonRow(160, 70),
              const SizedBox(height: 12),
              _buildFullSkeletonBar(),
              const SizedBox(height: 18),
              _buildSkeletonRow(110, 70),
            ],
          ),
        ),
        const SizedBox(height: 48),

        const Text(
          'No budget yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Set a spending limit per category. Flow lets you know\nwhen you get close to it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.subtle,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 28),
        ElevatedButton.icon(
          onPressed: () => _openAddOrEditBudget(context),
          icon: const Icon(Icons.add, size: 18, color: Colors.white),
          label: const Text(
            'Create a budget',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSkeletonRow(double leftWidth, double rightWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: leftWidth,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EEF8),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Container(
          width: rightWidth,
          height: 10,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EEF8),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildFullSkeletonBar() {
    return Container(
      width: double.infinity,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF8),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
