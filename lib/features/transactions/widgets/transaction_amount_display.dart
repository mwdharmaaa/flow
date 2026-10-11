import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class TransactionAmountDisplay extends StatefulWidget {
  final String amountText;
  final String categoryName;
  final bool isDark;

  const TransactionAmountDisplay({
    super.key,
    required this.amountText,
    required this.categoryName,
    required this.isDark,
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.amountText,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                  letterSpacing: -1,
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
