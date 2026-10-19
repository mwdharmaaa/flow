import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/core/formatters/currency_formatter.dart';

class TransactionAmountDisplay extends StatefulWidget {
  final String amountText;
  final String categoryName;
  final bool isDark;
  final String currency;
  final VoidCallback? onCurrencyTap;

  const TransactionAmountDisplay({
    super.key,
    required this.amountText,
    required this.categoryName,
    required this.isDark,
    this.currency = 'IDR',
    this.onCurrencyTap,
  });

  @override
  State<TransactionAmountDisplay> createState() => _TransactionAmountDisplayState();
}

class _TransactionAmountDisplayState extends State<TransactionAmountDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? const Color(0xFFFB923C) : const Color(0xFFC2410C);
    final cursorColor = widget.isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8);
    final subtitleColor = widget.isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B);
    final formattedAmount = CurrencyFormatter.formatAmountInput(
      widget.amountText,
      currency: widget.currency,
    );
    final symbol = CurrencyFormatter.getSymbol(widget.currency);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.onCurrencyTap != null)
              GestureDetector(
                onTap: widget.onCurrencyTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    color: widget.isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    symbol,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              )
            else
              Text(
                '$symbol ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
            Flexible(
              child: Text(
                formattedAmount,
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 2),
            FadeTransition(
              opacity: _cursorController,
              child: Container(
                width: 3.5,
                height: 42,
                decoration: BoxDecoration(
                  color: cursorColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Category: ${widget.categoryName}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}
