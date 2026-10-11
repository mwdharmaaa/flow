import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class VoicePresetChips extends StatelessWidget {
  final ValueChanged<String> onSelect;
  final bool isDark;

  static const List<String> suggestions = [
    'Nemu duit di jalan 50k',
    'Dikasi duit 100k di GoPay',
    'Tambah budget di GoPay 500k',
    'Tambah budget makanan 300k',
    'Matcha 28k dan esteh 3k',
    'Hapus histori hari ini',
    'Balikin semua history',
    'Hapus semua history saya',
  ];

  const VoicePresetChips({
    super.key,
    required this.onSelect,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contoh Perintah Suara Cepat:',
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
          children: suggestions.map((text) {
            return ActionChip(
              avatar: const Icon(Icons.mic, size: 14, color: AppTheme.primary),
              label: Text(
                '"$text"',
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
              onPressed: () => onSelect(text),
            );
          }).toList(),
        ),
      ],
    );
  }
}
