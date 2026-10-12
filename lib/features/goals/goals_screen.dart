import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/widgets/liquid_background.dart';
import 'package:flow/core/widgets/liquid_glass_container.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/goals/add_goal_dialog.dart';

class GoalsScreen extends StatelessWidget {
  final AppState state;

  const GoalsScreen({super.key, required this.state});

  void _promptTopUp(BuildContext context, String goalId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: state.isDarkMode ? AppTheme.darkBgElevated : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius(state.isDarkMode, 20)),
        title: Text('Add Savings', style: TextStyle(color: state.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(color: state.isDarkMode ? AppTheme.darkTextPrimary : AppTheme.textPrimary, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            labelText: 'Deposit Amount',
            prefixText: 'Rp ',
            labelStyle: TextStyle(color: AppTheme.subtle),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.subtle)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, elevation: 0),
            onPressed: () {
              final val = double.tryParse(controller.text.replaceAll(RegExp(r'[^0-9.]'), ''));
              if (val != null && val > 0) {
                state.updateGoalSavedAmount(goalId, val);
              }
              Navigator.pop(context);
            },
            child: const Text('Deposit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final totalTarget = state.goals.fold(0.0, (sum, g) => sum + g.targetAmount);
    final totalSaved = state.goals.fold(0.0, (sum, g) => sum + g.savedAmount);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LiquidGlassContainer(
                isDark: isDark,
                radius: 18,
                elevated: true,
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Savings Accumulated', style: TextStyle(fontSize: 11, color: textSecondary)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(totalSaved, currency: state.currency),
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Total target: ${CurrencyFormatter.format(totalTarget, currency: state.currency)}',
                          style: TextStyle(fontSize: 11, color: textSecondary),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddGoalDialog(onSave: (g) => state.addGoal(g)),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text('Create', style: TextStyle(color: Colors.white, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'SAVINGS GOALS (${state.goals.length})',
                style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: state.goals.isEmpty
                    ? Center(
                        child: LiquidGlassContainer(
                          isDark: isDark,
                          radius: 18,
                          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.savings_outlined, size: 36, color: textSecondary),
                              const SizedBox(height: 10),
                              Text('No savings goals yet', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                              const SizedBox(height: 4),
                              Text('Create a savings target for emergency funds, travel, or dreams', style: TextStyle(fontSize: 11, color: textSecondary), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 110),
                        physics: const BouncingScrollPhysics(),
                        cacheExtent: 300,
                        itemCount: state.goals.length,
                        itemBuilder: (_, idx) {
                          final g = state.goals[idx];
                          final percent = (g.progress * 100).toStringAsFixed(0);
                          return LiquidGlassContainer(
                            isDark: isDark,
                            radius: 16,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(g.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimary)),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, size: 16, color: textSecondary),
                                      onPressed: () => state.deleteGoal(g.id),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: g.progress,
                                  backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : AppTheme.primarySoft,
                                  valueColor: AlwaysStoppedAnimation<Color>(isDark ? AppTheme.darkAccentPrimary : AppTheme.primary),
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${CurrencyFormatter.format(g.savedAmount, currency: state.currency)} / ${CurrencyFormatter.format(g.targetAmount, currency: state.currency)} ($percent%)',
                                      style: TextStyle(fontSize: 11, color: textSecondary),
                                    ),
                                    TextButton(
                                      onPressed: () => _promptTopUp(context, g.id),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text('Deposit +', style: TextStyle(fontSize: 11, color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
