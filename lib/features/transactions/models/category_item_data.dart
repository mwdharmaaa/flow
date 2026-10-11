import 'package:flutter/material.dart';

class SubCategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const SubCategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CategoryItemData {
  final String name;
  final IconData icon;
  final Color color;
  final List<SubCategoryItem> subCategories;

  const CategoryItemData({
    required this.name,
    required this.icon,
    required this.color,
    this.subCategories = const [],
  });
}

class CategoryHierarchyData {
  static const List<CategoryItemData> recentlyUsedExpense = [
    CategoryItemData(
      name: 'Restaurants',
      icon: Icons.restaurant,
      color: Color(0xFF9E1B1E),
    ),
  ];

  static const List<CategoryItemData> expenseCategories = [
    CategoryItemData(
      name: 'Shopping',
      icon: Icons.checkroom,
      color: Color(0xFF9E0059),
      subCategories: [
        SubCategoryItem(
          name: 'Clothes',
          icon: Icons.checkroom,
          color: Color(0xFF9E0059),
        ),
        SubCategoryItem(
          name: 'Online Shopping',
          icon: Icons.local_shipping,
          color: Color(0xFFE11D48),
        ),
        SubCategoryItem(
          name: 'Gadgets & Electronics',
          icon: Icons.phone_android,
          color: Color(0xFF831843),
        ),
      ],
    ),
    CategoryItemData(
      name: 'Groceries',
      icon: Icons.shopping_basket,
      color: Color(0xFF0891B2),
    ),
    CategoryItemData(
      name: 'Entertainment',
      icon: Icons.sports_esports,
      color: Color(0xFFD97706),
    ),
    CategoryItemData(
      name: 'Investment',
      icon: Icons.savings,
      color: Color(0xFF0F172A),
      subCategories: [
        SubCategoryItem(
          name: 'Gold',
          icon: Icons.view_module,
          color: Color(0xFF1E1B4B),
        ),
      ],
    ),
    CategoryItemData(
      name: 'Restaurants',
      icon: Icons.restaurant,
      color: Color(0xFF9E1B1E),
    ),
    CategoryItemData(
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF2563EB),
    ),
    CategoryItemData(
      name: 'Bills',
      icon: Icons.receipt,
      color: Color(0xFFD97706),
    ),
    CategoryItemData(
      name: 'Health',
      icon: Icons.local_hospital,
      color: Color(0xFF059669),
    ),
    CategoryItemData(
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF0891B2),
    ),
  ];

  static const List<CategoryItemData> incomeCategories = [
    CategoryItemData(
      name: 'Business',
      icon: Icons.business_center,
      color: Color(0xFF064E3B),
    ),
    CategoryItemData(
      name: 'Bonus',
      icon: Icons.card_giftcard,
      color: Color(0xFFD97706),
    ),
    CategoryItemData(
      name: 'Salary',
      icon: Icons.payments,
      color: Color(0xFF0D9488),
    ),
    CategoryItemData(
      name: 'Investment',
      icon: Icons.trending_up,
      color: Color(0xFF0284C7),
    ),
    CategoryItemData(
      name: 'Gifts Received',
      icon: Icons.volunteer_activism,
      color: Color(0xFF9333EA),
    ),
    CategoryItemData(
      name: 'Sales',
      icon: Icons.sell,
      color: Color(0xFFE11D48),
    ),
    CategoryItemData(
      name: 'Loans',
      icon: Icons.credit_card,
      color: Color(0xFF1E40AF),
    ),
    CategoryItemData(
      name: 'All Categories',
      icon: Icons.extension,
      color: Color(0xFF64748B),
    ),
  ];

  static const List<CategoryItemData> transferCategories = [
    CategoryItemData(
      name: 'Cash Withdrawal',
      icon: Icons.atm,
      color: Color(0xFFB91C1C),
    ),
    CategoryItemData(
      name: 'Top Up',
      icon: Icons.keyboard_double_arrow_up,
      color: Color(0xFF059669),
    ),
    CategoryItemData(
      name: 'Transfer',
      icon: Icons.arrow_forward,
      color: Color(0xFFEA580C),
    ),
  ];
}
