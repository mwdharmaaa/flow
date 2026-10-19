import 'package:intl/intl.dart';

class CurrencyOption {
  final String code;
  final String symbol;
  final String name;
  final String locale;
  final int decimalDigits;
  final String thousandSeparator;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
    required this.locale,
    this.decimalDigits = 2,
    this.thousandSeparator = ',',
  });
}

class CurrencyFormatter {
  static const List<CurrencyOption> supportedCurrencies = [
    CurrencyOption(
      code: 'IDR',
      symbol: 'Rp',
      name: 'Indonesian Rupiah',
      locale: 'id_ID',
      decimalDigits: 0,
      thousandSeparator: '.',
    ),
    CurrencyOption(
      code: 'USD',
      symbol: '\$',
      name: 'US Dollar',
      locale: 'en_US',
      decimalDigits: 2,
      thousandSeparator: ',',
    ),
    CurrencyOption(
      code: 'EUR',
      symbol: '€',
      name: 'Euro',
      locale: 'de_DE',
      decimalDigits: 2,
      thousandSeparator: '.',
    ),
    CurrencyOption(
      code: 'GBP',
      symbol: '£',
      name: 'British Pound',
      locale: 'en_GB',
      decimalDigits: 2,
      thousandSeparator: ',',
    ),
    CurrencyOption(
      code: 'SGD',
      symbol: 'S\$',
      name: 'Singapore Dollar',
      locale: 'en_SG',
      decimalDigits: 2,
      thousandSeparator: ',',
    ),
    CurrencyOption(
      code: 'MYR',
      symbol: 'RM',
      name: 'Malaysian Ringgit',
      locale: 'ms_MY',
      decimalDigits: 2,
      thousandSeparator: ',',
    ),
    CurrencyOption(
      code: 'JPY',
      symbol: '¥',
      name: 'Japanese Yen',
      locale: 'ja_JP',
      decimalDigits: 0,
      thousandSeparator: ',',
    ),
    CurrencyOption(
      code: 'AUD',
      symbol: 'A\$',
      name: 'Australian Dollar',
      locale: 'en_AU',
      decimalDigits: 2,
      thousandSeparator: ',',
    ),
  ];

  static CurrencyOption findOption(String currency) {
    return supportedCurrencies.firstWhere(
      (c) => c.code.toUpperCase() == currency.toUpperCase(),
      orElse: () => supportedCurrencies.first,
    );
  }

  static String getSymbol(String currency) {
    return findOption(currency).symbol;
  }

  static String format(double amount, {String currency = 'IDR'}) {
    final opt = findOption(currency);
    final formatter = NumberFormat.currency(
      locale: opt.locale,
      symbol: '${opt.symbol} ',
      decimalDigits: opt.decimalDigits,
    );
    return formatter.format(amount);
  }

  static String formatAmountInput(String input, {String currency = 'IDR'}) {
    if (input.isEmpty) return '0';
    final opt = findOption(currency);
    final separator = opt.thousandSeparator;

    final regex = RegExp(r'(\d+)|([^\d\s]+)');
    final matches = regex.allMatches(input);

    final buffer = StringBuffer();
    for (final match in matches) {
      final digits = match.group(1);
      final op = match.group(2);
      if (digits != null) {
        buffer.write(_insertSeparators(digits, separator));
      } else if (op != null) {
        buffer.write(' $op ');
      }
    }

    return buffer.toString().trim();
  }

  static String _insertSeparators(String digits, String separator) {
    if (digits.length <= 3) return digits;
    final buffer = StringBuffer();
    final len = digits.length;
    for (int i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static double parseAmount(String input, {String currency = 'IDR'}) {
    if (input.isEmpty) return 0.0;
    final opt = findOption(currency);
    String clean = input.replaceAll(' ', '');
    if (opt.thousandSeparator == '.') {
      clean = clean.replaceAll('.', '').replaceAll(',', '.');
    } else {
      clean = clean.replaceAll(',', '');
    }
    clean = clean.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }
}
