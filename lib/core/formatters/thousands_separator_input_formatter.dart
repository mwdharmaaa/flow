import 'package:flutter/services.dart';
import 'package:flow/core/formatters/currency_formatter.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final String currency;

  ThousandsSeparatorInputFormatter({this.currency = 'IDR'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final cleanDigits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanDigits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formatted = CurrencyFormatter.formatAmountInput(cleanDigits, currency: currency);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
