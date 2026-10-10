import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class AccountBannerCards extends StatelessWidget {
  const AccountBannerCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flow Premium Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F7FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2EDFE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.workspace_premium_outlined, size: 16, color: AppTheme.primary),
                  SizedBox(width: 6),
                  Text(
                    'FLOW PREMIUM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Money tracking, no limits.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Recurring transactions, Excel export, receipt attachments, dark mode and more.',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.subtle,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Text(
                    'See plans',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 16, color: AppTheme.primary),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Referral Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFEDD5)),
          ),
          child: const Row(
            children: [
              Icon(Icons.card_giftcard_rounded, size: 20, color: Color(0xFFD97706)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite friends, earn commission',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your code NKJQEM • unlimited commission',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.subtle,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: AppTheme.subtle),
            ],
          ),
        ),
      ],
    );
  }
}
