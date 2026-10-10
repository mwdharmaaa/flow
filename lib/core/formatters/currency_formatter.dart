import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount, {String currency = 'IDR'}) {
    if (currency == 'IDR') {
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    }

    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '$currency ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy', 'id_ID').format(date);
  }
}
