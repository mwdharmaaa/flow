import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/features/transactions/models/category_item_data.dart';

class TransactionCategoryChips extends StatelessWidget {
  final String selectedCategory;
  final List<CategoryItemData> categories;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onAllTap;
  final bool isDark;

  const TransactionCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    required this.onAllTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure selectedCategory is represented in display list
    final hasSelected = categories.any((c) => c.name.toLowerCase() == selectedCategory.toLowerCase());
    final displayList = <CategoryItemData>[
      if (!hasSelected)
        CategoryItemData(
          name: selectedCategory,
          icon: Icons.category_rounded,
          color: const Color(0xFF1D61E0),
        ),
      ...categories,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: displayList.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAllChip();
          }

          final cat = displayList[index - 1];
          final isSelected = cat.name.toLowerCase() == selectedCategory.toLowerCase();
          return _buildCategoryChip(cat, isSelected);
        },
      ),
    );
  }

  Widget _buildAllChip() {
    return Material(
      color: isDark ? AppTheme.darkBgElevated : Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onAllTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE2E8F0),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(CategoryItemData cat, bool isSelected) {
    Color bg;
    Color border;
    Color fg;

    if (isSelected) {
      bg = isDark ? const Color(0xFF2563EB) : const Color(0xFF0F172A);
      border = Colors.transparent;
      fg = Colors.white;
    } else {
      bg = isDark ? AppTheme.darkBgElevated : Colors.white;
      border = isDark ? AppTheme.darkBorderSubtle : const Color(0xFFE2E8F0);
      fg = isDark ? AppTheme.darkTextPrimary : const Color(0xFF1E293B);
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => onCategorySelected(cat.name),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: border),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: cat.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(cat.icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                cat.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
