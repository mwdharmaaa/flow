import 'package:flow/models/receipt_model.dart';

class ReceiptParser {
  static const List<String> _knownMerchants = [
    'Indomaret',
    'Alfamart',
    'Starbucks',
    'Kopi Kenangan',
    'Superindo',
    'Warung Padang',
    'KFC',
    'McDonalds',
    'Janji Jiwa',
    'Transmart',
    'Apotek Kimia Farma',
  ];

  static ReceiptData parse(String rawText) {
    final lines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    if (lines.isEmpty) {
      return ReceiptData(
        merchant: 'Unknown Store',
        date: DateTime.now(),
        items: const [],
        subtotal: 0.0,
        tax: 0.0,
        total: 0.0,
        suggestedCategory: 'Shopping',
        rawText: rawText,
      );
    }

    String detectedMerchant = _detectMerchant(lines);
    List<ReceiptItem> parsedItems = [];
    double detectedSubtotal = 0.0;
    double detectedTax = 0.0;
    double detectedTotal = 0.0;

    for (final line in lines) {
      final lower = line.toLowerCase();

      if (lower.startsWith('total') || lower.startsWith('grand total') || lower.startsWith('jumlah bayar')) {
        detectedTotal = _extractAmount(line);
      } else if (lower.startsWith('subtotal') || lower.startsWith('sub total')) {
        detectedSubtotal = _extractAmount(line);
      } else if (lower.contains('ppn') || lower.contains('tax') || lower.contains('pajak')) {
        detectedTax = _extractAmount(line);
      } else {
        final item = _parseItemLine(line);
        if (item != null) {
          parsedItems.add(item);
        }
      }
    }

    if (detectedTotal <= 0 && parsedItems.isNotEmpty) {
      detectedTotal = parsedItems.fold(0.0, (sum, i) => sum + (i.price * i.quantity));
    }

    if (detectedSubtotal <= 0) {
      detectedSubtotal = detectedTotal - detectedTax;
    }

    final category = _inferCategory(detectedMerchant, parsedItems);

    return ReceiptData(
      merchant: detectedMerchant,
      date: DateTime.now(),
      items: parsedItems,
      subtotal: detectedSubtotal > 0 ? detectedSubtotal : detectedTotal,
      tax: detectedTax,
      total: detectedTotal,
      suggestedCategory: category,
      rawText: rawText,
    );
  }

  static String _detectMerchant(List<String> lines) {
    for (final line in lines.take(4)) {
      for (final m in _knownMerchants) {
        if (line.toLowerCase().contains(m.toLowerCase())) {
          return m;
        }
      }
    }
    return lines.first.length < 30 ? lines.first : 'Retail Store';
  }

  static ReceiptItem? _parseItemLine(String line) {
    final clean = line.replaceAll(RegExp(r'\s+'), ' ');
    final priceMatch = RegExp(r'(\d{1,3}(?:[.,]\d{3})*|\d+)(?:\s*(?:k|rb))?$').firstMatch(clean);
    if (priceMatch == null) return null;

    final priceStr = priceMatch.group(1) ?? '0';
    final price = _cleanNumber(priceStr);
    if (price <= 0) return null;

    String name = clean.substring(0, priceMatch.start).trim();
    if (name.isEmpty || name.length < 2) return null;

    int qty = 1;
    final qtyMatch = RegExp(r'^(\d+)\s*[xX]\s*').firstMatch(name);
    if (qtyMatch != null) {
      qty = int.tryParse(qtyMatch.group(1) ?? '1') ?? 1;
      name = name.substring(qtyMatch.end).trim();
    }

    return ReceiptItem(name: name, quantity: qty, price: price);
  }

  static double _extractAmount(String line) {
    final match = RegExp(r'(\d{1,3}(?:[.,]\d{3})*|\d+)').allMatches(line);
    if (match.isEmpty) return 0.0;
    return _cleanNumber(match.last.group(1) ?? '0');
  }

  static double _cleanNumber(String str) {
    final raw = str.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(raw) ?? 0.0;
  }

  static String _inferCategory(String merchant, List<ReceiptItem> items) {
    final mLower = merchant.toLowerCase();
    if (mLower.contains('kopi') ||
        mLower.contains('starbucks') ||
        mLower.contains('kfc') ||
        mLower.contains('mcdonalds') ||
        mLower.contains('padang') ||
        mLower.contains('resto') ||
        mLower.contains('cafe')) {
      return 'Food';
    }
    if (mLower.contains('apotek') || mLower.contains('farma')) {
      return 'Health';
    }
    return 'Shopping';
  }
}
