import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/settings/widgets/account_profile_card.dart';
import 'package:flow/features/settings/widgets/account_banner_cards.dart';
import 'package:flow/features/settings/widgets/account_menu_item.dart';

class SettingsScreen extends StatelessWidget {
  final AppState state;
  final VoidCallback onOpenWallets;
  final VoidCallback onOpenDebts;
  final VoidCallback onOpenRecurring;
  final VoidCallback onOpenBudgets;
  final VoidCallback onOpenGoals;

  const SettingsScreen({
    super.key,
    required this.state,
    required this.onOpenWallets,
    required this.onOpenDebts,
    required this.onOpenRecurring,
    required this.onOpenBudgets,
    required this.onOpenGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Version 3.1.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.subtle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Profile & Streak Card
              AccountProfileCard(
                streakDays: 0,
                entryCount: state.transactions.length,
              ),
              const SizedBox(height: 16),

              // Premium & Invite Banners
              const AccountBannerCards(),
              const SizedBox(height: 24),

              // Section: Features
              _buildSectionTitle('Features'),
              const AccountMenuItem(
                icon: Icons.alt_route_rounded,
                title: 'Automatic rules',
                subtitle: 'Categories fill in by themselves, following your rules',
                value: '0 active',
              ),
              const AccountMenuItem(
                icon: Icons.power_outlined,
                title: 'Integrations',
                subtitle: 'Notifications, WhatsApp, Telegram, screenshots',
                value: '1 active',
              ),
              const AccountMenuItem(
                icon: Icons.tune_rounded,
                title: 'Manage features',
                subtitle: 'Overview, debts, ways to log',
              ),
              AccountMenuItem(
                icon: Icons.badge_outlined,
                title: 'Debt contacts',
                value: '${state.debts.length} people',
                onTap: onOpenDebts,
              ),
              AccountMenuItem(
                icon: Icons.sync_rounded,
                title: 'Recurring transactions',
                value: 'Premium',
                onTap: onOpenRecurring,
              ),
              const AccountMenuItem(
                icon: Icons.alarm_rounded,
                title: 'Daily reminder',
                value: 'Off',
              ),
              const SizedBox(height: 20),

              // Section: Finances
              _buildSectionTitle('Finances'),
              AccountMenuItem(
                icon: Icons.account_balance_wallet_outlined,
                title: 'Wallets',
                value: '${state.accounts.length} wallets',
                onTap: onOpenWallets,
              ),
              AccountMenuItem(
                icon: Icons.attach_money_rounded,
                title: 'Main currency',
                value: state.currency,
                onTap: () {
                  final next = state.currency == 'IDR' ? 'USD' : (state.currency == 'USD' ? 'EUR' : 'IDR');
                  state.setCurrency(next);
                },
              ),
              const AccountMenuItem(
                icon: Icons.category_outlined,
                title: 'Categories',
                value: '29 categories',
              ),
              const AccountMenuItem(
                icon: Icons.calendar_today_outlined,
                title: 'Month start',
                subtitle: 'Period 1-31 Oct',
                value: 'day 1',
              ),
              AccountMenuItem(
                icon: Icons.pie_chart_outline_rounded,
                title: 'Budget',
                value: state.budgets.isEmpty ? 'Not set' : '${state.budgets.length} set',
                onTap: onOpenBudgets,
              ),
              const SizedBox(height: 20),

              // Section: Security & Data
              _buildSectionTitle('Security & data'),
              const AccountMenuItem(
                icon: Icons.lock_outline_rounded,
                title: 'App PIN',
                value: 'Off',
              ),
              const AccountMenuItem(
                icon: Icons.file_upload_outlined,
                title: 'Export data',
                value: 'Premium',
              ),
              const SizedBox(height: 20),

              // Community Help Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.favorite, size: 16, color: Color(0xFFE11D48)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Is Flow helping you?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Share it with friends or family. Share now',
                            style: TextStyle(fontSize: 11, color: AppTheme.subtle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: More
              _buildSectionTitle('More'),
              const AccountMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Appearance',
                value: 'Light',
              ),
              const AccountMenuItem(
                icon: Icons.language_rounded,
                title: 'Language',
                value: 'English',
              ),
              const AccountMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'FAQ',
              ),
              AccountMenuItem(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Send feedback',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback feature opened locally')),
                  );
                },
              ),
              const AccountMenuItem(
                icon: Icons.shield_outlined,
                title: 'Privacy & terms',
              ),
              AccountMenuItem(
                icon: Icons.logout_rounded,
                title: 'Log out',
                textColor: AppTheme.expense,
                iconColor: AppTheme.expense,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Reset Data'),
                      content: const Text('Reset all local data back to zero defaults?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.expense),
                          onPressed: () {
                            state.resetToDefaults();
                            Navigator.pop(ctx);
                          },
                          child: const Text('Reset', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.subtle,
        ),
      ),
    );
  }
}
