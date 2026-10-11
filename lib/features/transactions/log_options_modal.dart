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
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgBase : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBorderSubtle : AppTheme.border,
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildOptionTile(
            context: context,
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
            context: context,
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
            context: context,
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
            context: context,
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
            context: context,
            icon: Icons.people_outline_rounded,
            title: 'Debts',
            subtitle: 'Lend to a friend, or log what you owe.',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).pop();
              state.setTabIndex(4);
            },
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkBgElevated : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF2563EB),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.subtle,
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
