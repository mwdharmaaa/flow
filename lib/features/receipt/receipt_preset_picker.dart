import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class ReceiptPreset {
  final String label;
  final String store;
  final String rawText;

  const ReceiptPreset({
    required this.label,
    required this.store,
    required this.rawText,
  });
}

class ReceiptPresetPicker extends StatelessWidget {
  final Function(String rawText) onSelectPreset;
  final bool isDark;

  static const List<ReceiptPreset> presets = [
    ReceiptPreset(
      label: 'Indomaret Belanja',
      store: 'Indomaret Point',
      rawText: '''INDOMARET POINT SUDIRMAN
2 x ROTI TAWAR 16.000
1 x SUSU ULTRA MILK 1L 21.500
1 x MIE INSTANT GORENG 3.500
SUBTOTAL 41.000
PPN 11% 4.510
TOTAL 45.510''',
    ),
    ReceiptPreset(
      label: 'Kopi Kenangan',
      store: 'Kopi Kenangan',
      rawText: '''KOPI KENANGAN GRAND INDO
1 x KOPI KENANGAN MANTAN 19.000
1 x TOAST COKLAT 22.000
SUBTOTAL 41.000
PPN 4.100
TOTAL 45.100''',
    ),
    ReceiptPreset(
      label: 'Alfamart Minimarket',
      store: 'Alfamart',
      rawText: '''ALFAMART GATSU
1 x AIR MINERAL 600ML 4.000
2 x SNACK CHITATO 22.000
1 x SABUN MANDI REFILL 18.000
TOTAL 44.000''',
    ),
    ReceiptPreset(
      label: 'Warung Nasi Padang',
      store: 'Warung Padang Sederhana',
      rawText: '''WARUNG PADANG SEDERHANA
1 x NASI RENDANG 28.000
1 x ES TEH MANIS 5.000
1 x PERKEDEL 6.000
TOTAL 39.000''',
    ),
  ];

  const ReceiptPresetPicker({
    super.key,
    required this.onSelectPreset,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Simulasi Contoh Struk Riil:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets.map((p) {
            return ActionChip(
              avatar: const Icon(Icons.receipt, size: 14, color: AppTheme.primary),
              label: Text(
                p.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                ),
              ),
              backgroundColor: isDark ? AppTheme.darkBgElevated : Colors.white,
              side: BorderSide(
                color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border,
              ),
              onPressed: () => onSelectPreset(p.rawText),
            );
          }).toList(),
        ),
      ],
    );
  }
}
