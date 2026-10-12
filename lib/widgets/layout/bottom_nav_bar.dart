import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xCC16161F) : Colors.white.withValues(alpha: 0.85);
    final navBorder = isDark ? AppTheme.darkBorderSubtle : AppTheme.border.withValues(alpha: 0.8);
    final activeColor = isDark ? AppTheme.darkAccentPrimary : AppTheme.primary;
    final inactiveColor = isDark ? AppTheme.darkTextSecondary : AppTheme.subtle;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final navRadius = AppTheme.borderRadius(isDark, 34);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      child: ClipRRect(
        borderRadius: navRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: navBg,
              borderRadius: navRadius,
              border: Border.all(color: navBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
                  blurRadius: 22,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.bar_chart_outlined,
              activeIcon: Icons.bar_chart_rounded,
              label: 'Reports',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            // Center Floating Action Button
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            _buildNavItem(
              index: 2,
              icon: Icons.pie_chart_outline_rounded,
              activeIcon: Icons.pie_chart_rounded,
              label: 'Budget',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
            _buildNavItem(
              index: 3,
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet_rounded,
              label: 'Wallets',
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ],
        ),
      ),
    ),
  ),
);
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 23,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
