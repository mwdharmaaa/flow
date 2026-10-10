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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('LANGGANAN & TAGIHAN RUTIN', style: TextStyle(fontSize: 11, color: AppTheme.subtle, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: state.recurring.isEmpty
                  ? const Center(child: Text('Belum ada langganan rutin.', style: TextStyle(fontSize: 12, color: AppTheme.subtle)))
                  : ListView.builder(
                      itemCount: state.recurring.length,
                      itemBuilder: (_, idx) {
                        final r = state.recurring[idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.border.withValues(alpha: 0.7)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.autorenew, color: AppTheme.primary, size: 22),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                                    Text('${r.category} • ${r.interval.toUpperCase()}', style: const TextStyle(fontSize: 10, color: AppTheme.subtle)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(r.amount, currency: state.currency),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Switch(
                                    value: r.isActive,
                                    activeColor: AppTheme.income,
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
