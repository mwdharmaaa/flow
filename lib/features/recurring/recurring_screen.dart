import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';

class RecurringScreen extends StatelessWidget {
  final AppState state;

  const RecurringScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RECURRING BILLS & SUBSCRIPTIONS',
              style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: state.recurring.isEmpty
                  ? const Center(child: Text('No recurring subscriptions recorded yet.', style: TextStyle(fontSize: 13, color: AppTheme.subtle)))
                  : ListView.builder(
                      itemCount: state.recurring.length,
                      itemBuilder: (_, idx) {
                        final r = state.recurring[idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: AppTheme.primarySoft,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.autorenew_rounded, color: AppTheme.primary, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                                    const SizedBox(height: 2),
                                    Text('${r.category} • ${r.interval.toUpperCase()}', style: const TextStyle(fontSize: 10, color: AppTheme.subtle)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(r.amount, currency: state.currency),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                  ),
                                  Switch(
                                    value: r.isActive,
                                    activeColor: AppTheme.primary,
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
    );
  }
}
