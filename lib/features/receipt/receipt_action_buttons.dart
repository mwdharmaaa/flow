import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class ReceiptActionButtons extends StatelessWidget {
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;
  final bool isDark;
  final bool isScanning;

  const ReceiptActionButtons({
    super.key,
    required this.onTapCamera,
    required this.onTapGallery,
    required this.isDark,
    this.isScanning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isScanning ? null : onTapCamera,
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text('Buka Kamera', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: isScanning ? null : onTapGallery,
            icon: Icon(Icons.photo_library_outlined, size: 18, color: isDark ? AppTheme.darkAccentPrimary : AppTheme.primary),
            label: Text(
              'Pilih Galeri',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
