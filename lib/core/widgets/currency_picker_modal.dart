import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';
import 'package:flow/state/app_state.dart';

class CurrencyPickerModal extends StatelessWidget {
  final AppState state;

  const CurrencyPickerModal({super.key, required this.state});

  static Future<void> show(BuildContext context, AppState state) {
    final isDark = state.isDarkMode;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CurrencyPickerModal(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final currentCurrency = state.currency;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final radius = AppTheme.verticalTop(isDark, 28);
    final textPrimary = isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary;
    final textSecondary = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1422) : Colors.white,
        borderRadius: radius,
        border: Border.all(
          color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'App-wide currency & number formatting',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                color: textSecondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: CurrencyFormatter.supportedCurrencies.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final option = CurrencyFormatter.supportedCurrencies[index];
                final isSelected = option.code.toUpperCase() == currentCurrency.toUpperCase();

                return GestureDetector(
                  onTap: () {
                    state.setCurrency(option.code);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? AppTheme.darkAccentPrimary.withValues(alpha: 0.15) : AppTheme.primarySoft)
                          : (isDark ? const Color(0xFF161C2C) : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? AppTheme.darkAccentPrimary : AppTheme.primary)
                            : (isDark ? const Color(0xFF222B3E) : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? AppTheme.darkAccentPrimary : AppTheme.primary)
                                : (isDark ? const Color(0xFF232D42) : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            option.code,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                              Text(
                                'Symbol: ${option.symbol}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
