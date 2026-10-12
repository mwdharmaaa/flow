import 'package:flutter/material.dart';

class TransactionCalculatorKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyTap;
  final bool isDark;

  const TransactionCalculatorKeypad({
    super.key,
    required this.onKeyTap,
    required this.isDark,
  });

  static const List<List<String>> _keyRows = [
    ['C', '÷', '×', '⌫'],
    ['7', '8', '9', '-'],
    ['4', '5', '6', '+'],
    ['1', '2', '3', '='],
    ['0', '00', '000', 'OK'],
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(14, 10, 14, 10 + bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0F1D) : const Color(0xFFEFF4FA),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _keyRows.map((row) => _buildRow(row)).toList(),
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: keys.map((key) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildKeyButton(key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyButton(String key) {
    final isOk = key == 'OK';
    final isOp = ['C', '÷', '×', '⌫', '-', '+', '='].contains(key);

    Color bg;
    Color fg;

    if (isOk) {
      bg = const Color(0xFF1D61E0);
      fg = Colors.white;
    } else if (isOp) {
      bg = isDark ? const Color(0xFF132338) : const Color(0xFFDCE8F8);
      fg = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1D4ED8);
    } else {
      bg = isDark ? const Color(0xFF1E293B) : Colors.white;
      fg = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    }

    return Material(
      color: bg,
      borderRadius: AppTheme.borderRadius(isDark, 14),
      elevation: (!isOp && !isOk && !isDark) ? 1 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => onKeyTap(key),
        borderRadius: AppTheme.borderRadius(isDark, 14),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: key == '⌫'
              ? Icon(Icons.backspace_outlined, size: 20, color: fg)
              : Text(
                  key,
                  style: TextStyle(
                    fontSize: isOk ? 16 : 20,
                    fontWeight: isOk ? FontWeight.w800 : FontWeight.w600,
                    color: fg,
                  ),
                ),
        ),
      ),
    );
  }
}
