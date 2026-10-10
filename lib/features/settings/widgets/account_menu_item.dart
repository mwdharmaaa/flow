import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;

  const AccountMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: iconColor ?? AppTheme.primary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppTheme.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.subtle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.subtle,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.chevron_right,
              size: 18,
              color: AppTheme.subtle.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
