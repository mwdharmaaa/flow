import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class AccountProfileCard extends StatelessWidget {
  final int streakDays;
  final int entryCount;

  const AccountProfileCard({
    super.key,
    this.streakDays = 0,
    this.entryCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User Info Row
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'K',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kresna Dwipananda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'kresnadwipananda@gmail.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.subtle,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppTheme.subtle),
          ],
        ),
        const SizedBox(height: 18),

        // Streak & Entries Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department, size: 18, color: Color(0xFFFF7A00)),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$streakDays',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Text(
                          'day streak',
                          style: TextStyle(fontSize: 11, color: AppTheme.subtle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 32, color: AppTheme.border),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$entryCount',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Text(
                      'entries',
                      style: TextStyle(fontSize: 11, color: AppTheme.subtle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
