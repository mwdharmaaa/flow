import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/budgets/add_budget_dialog.dart';

class BudgetsScreen extends StatelessWidget {
  final AppState state;

  const BudgetsScreen({super.key, required this.state});

  void _openAddBudget(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddBudgetDialog(onSave: (bgt) => state.addBudget(bgt)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Budget',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 36),

              if (state.budgets.isEmpty)
                _buildEmptyState(context)
              else
                _buildBudgetList(context),
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

        // Text & Call to Action
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
          onPressed: () => _openAddBudget(context),
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

  Widget _buildBudgetList(BuildContext context) {
    return Column(
      children: state.budgets.map((b) {
        final percent = (b.spent / b.monthlyLimit).clamp(0.0, 1.0);
        final isOver = b.spent > b.monthlyLimit;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    b.category,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    isOver
                        ? 'Over Budget'
                        : 'Left: ${CurrencyFormatter.format(b.monthlyLimit - b.spent, currency: state.currency)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isOver ? AppTheme.expense : AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: percent,
                  backgroundColor: AppTheme.primarySoft,
                  valueColor: AlwaysStoppedAnimation(
                    isOver ? AppTheme.expense : AppTheme.primary,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spent: ${CurrencyFormatter.format(b.spent, currency: state.currency)}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                  ),
                  Text(
                    'Limit: ${CurrencyFormatter.format(b.monthlyLimit, currency: state.currency)}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.subtle),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
