import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/core/widgets/liquid_background.dart';
import 'package:flow/core/widgets/liquid_glass_container.dart';
import 'package:flow/state/app_state.dart';

class RecurringScreen extends StatelessWidget {
  final AppState state;

  const RecurringScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final accentColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LiquidBackground(
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECURRING BILLS & SUBSCRIPTIONS',
                style: TextStyle(
                  fontSize: 11,
                  color: textSecondary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: state.recurring.isEmpty
                    ? Center(
                        child: Text(
                          'No recurring subscriptions recorded yet.',
                          style: TextStyle(fontSize: 13, color: textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 110),
                        physics: const BouncingScrollPhysics(),
                        cacheExtent: 300,
                        itemCount: state.recurring.length,
                        itemBuilder: (_, idx) {
                          final r = state.recurring[idx];
                          return LiquidGlassContainer(
                            isDark: isDark,
                            radius: 16,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppTheme.darkBgSurface : AppTheme.primarySoft,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.autorenew_rounded,
                                    color: accentColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${r.category} • ${r.interval.toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(r.amount, currency: state.currency),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Switch(
                                      value: r.isActive,
                                      activeColor: accentColor,
                                      onChanged: (_) => state.toggleRecurring(r.id),
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
