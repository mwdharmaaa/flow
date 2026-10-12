import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/features/transactions/add_transaction_dialog.dart';
import 'package:flow/features/transactions/models/category_item_data.dart';

class ChooseCategoryModal extends StatefulWidget {
  final AppState state;
  final TransactionType initialType;
  final ValueChanged<String>? onCategoryPicked;

  const ChooseCategoryModal({
    super.key,
    required this.state,
    this.initialType = TransactionType.expense,
    this.onCategoryPicked,
  });

  static Future<void> show(
    BuildContext context,
    AppState state, {
    TransactionType initialType = TransactionType.expense,
    ValueChanged<String>? onCategoryPicked,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChooseCategoryModal(
        state: state,
        initialType: initialType,
        onCategoryPicked: onCategoryPicked,
      ),
    );
  }

  @override
  State<ChooseCategoryModal> createState() => _ChooseCategoryModalState();
}

class _ChooseCategoryModalState extends State<ChooseCategoryModal> {
  late TransactionType _activeTab;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialType;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(TransactionType type, String category) {
    Navigator.of(context).pop();
    if (widget.onCategoryPicked != null) {
      widget.onCategoryPicked!(category);
      return;
    }
    AddTransactionDialog.show(
      context,
      state: widget.state,
      initialType: type,
      initialCategory: category,
    );
  }

  List<CategoryItemData> _getFilteredCategories() {
    List<CategoryItemData> base;
    switch (_activeTab) {
      case TransactionType.income:
        base = CategoryHierarchyData.incomeCategories;
        break;
      case TransactionType.transfer:
        base = CategoryHierarchyData.transferCategories;
        break;
      case TransactionType.expense:
      default:
        base = CategoryHierarchyData.expenseCategories;
        break;
    }

    if (_searchQuery.isEmpty) return base;

    final q = _searchQuery.toLowerCase();
    return base.where((cat) {
      final nameMatches = cat.name.toLowerCase().contains(q);
      final subMatches = cat.subCategories.any((s) => s.name.toLowerCase().contains(q));
      return nameMatches || subMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.state.isDarkMode;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
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
              margin: const EdgeInsets.only(bottom: 14),
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
                'Choose category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  foregroundColor: const Color(0xFF2563EB),
                ),
                child: const Text(
                  'Manage',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSegmentedTabs(isDark),
          const SizedBox(height: 12),
          _buildSearchBar(isDark),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                if (_activeTab == TransactionType.expense && _searchQuery.isEmpty) ...[
                  _buildSectionHeader('Recently used', isDark),
                  const SizedBox(height: 10),
                  _buildRecentlyUsedRow(isDark),
                  const SizedBox(height: 18),
                ],
                _buildSectionHeader('All categories', isDark),
                const SizedBox(height: 10),
                ..._buildCategoryItems(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs(bool isDark) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : const Color(0xFFF1F5F9),
        borderRadius: AppTheme.borderRadius(isDark, 16),
      ),
      child: Row(
        children: [
          _buildTabItem('Expense', TransactionType.expense, isDark),
          _buildTabItem('Income', TransactionType.income, isDark),
          _buildTabItem('Transfer', TransactionType.transfer, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, TransactionType type, bool isDark) {
    final isSelected = _activeTab == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppTheme.darkBgBase : Colors.white)
                : Colors.transparent,
            borderRadius: AppTheme.borderRadius(isDark, 12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A))
                  : (isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBgElevated : const Color(0xFFF8FAFC),
        borderRadius: AppTheme.borderRadius(isDark, 24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 19,
            color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: 'Search categories',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildRecentlyUsedRow(bool isDark) {
    final recent = CategoryHierarchyData.recentlyUsedExpense.first;
    return GestureDetector(
      onTap: () => _onCategorySelected(_activeTab, recent.name),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: recent.color,
              shape: BoxShape.circle,
            ),
            child: Icon(recent.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            recent.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryItems(bool isDark) {
    final categories = _getFilteredCategories();
    return categories.map((cat) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemTile(
            title: cat.name,
            icon: cat.icon,
            color: cat.color,
            isDark: isDark,
            onTap: () => _onCategorySelected(_activeTab, cat.name),
          ),
          if (cat.subCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 1.5,
                      margin: const EdgeInsets.only(top: 2, bottom: 8),
                      color: isDark
                          ? AppTheme.darkBorderSubtle
                          : const Color(0xFFCBD5E1),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: cat.subCategories.map((sub) {
                          return _buildItemTile(
                            title: sub.name,
                            icon: sub.icon,
                            color: sub.color,
                            isDark: isDark,
                            isSub: true,
                            onTap: () => _onCategorySelected(_activeTab, sub.name),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? AppTheme.darkBorderSubtle : const Color(0xFFF1F5F9),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildItemTile({
    required String title,
    required IconData icon,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
    bool isSub = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.borderRadius(isDark, 10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isSub ? 8 : 10),
        child: Row(
          children: [
            Container(
              width: isSub ? 32 : 40,
              height: isSub ? 32 : 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: isSub ? 16 : 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isSub ? 13 : 15,
                  fontWeight: isSub ? FontWeight.w500 : FontWeight.w600,
                  color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
