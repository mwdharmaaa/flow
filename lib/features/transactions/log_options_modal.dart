import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/chat/chat_assistant_modal.dart';
import 'package:flow/features/voice/voice_assistant_modal.dart';
import 'package:flow/features/receipt/receipt_scanner_modal.dart';
import 'package:flow/features/transactions/choose_category_modal.dart';

class LogOptionsModal extends StatelessWidget {
  final AppState state;

  const LogOptionsModal({super.key, required this.state});

  static Future<void> show(BuildContext context, AppState state) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogOptionsModal(state: state),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = state.isDarkMode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 24 + bottomInset),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgBase : Colors.white,
        borderRadius: AppTheme.verticalTop(isDark, 30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How do you want to log it?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBgElevated : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Type',
            subtitle: 'Chat to Moni as usual: "lunch 5k".',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).pop();
              ChatAssistantModal.show(context, state);
            },
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: Icons.mic_none_rounded,
            title: 'Speak',
            subtitle: '"Coffee 28k, fuel 50k."',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).pop();
              VoiceAssistantModal.show(context, state);
            },
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: Icons.receipt_long_outlined,
            title: 'Receipt photo',
            subtitle: 'Point at the receipt, Moni reads the rest.',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).pop();
              ReceiptScannerModal.show(context, state);
            },
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: Icons.edit_outlined,
            title: 'Manual',
            subtitle: 'Fill in the form yourself, transfers included.',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).pop();
              ChooseCategoryModal.show(context, state);
            },
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: Icons.people_outline_rounded,
            title: 'Debts',
            subtitle: 'Lend to a friend, or log what you owe.',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).pop();
              state.setTabIndex(4);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Auto',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkBgElevated : Colors.white,
                  borderRadius: AppTheme.borderRadius(isDark, 20),
                  border: Border.all(
                    color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 16,
                      color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFF1F5F9),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
