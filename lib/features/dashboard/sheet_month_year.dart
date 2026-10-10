import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class SheetMonthYear extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onSelect;

  const SheetMonthYear({
    super.key,
    required this.initialDate,
    required this.onSelect,
  });

  @override
  State<SheetMonthYear> createState() => _SheetMonthYearState();
}

class _SheetMonthYearState extends State<SheetMonthYear> {
  late int _selectedYear;

  final List<String> _months = const [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white70),
                onPressed: () => setState(() => _selectedYear--),
              ),
              Text(
                '$_selectedYear',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white70),
                onPressed: () => setState(() => _selectedYear++),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (_, index) {
              final isCurrent = index + 1 == widget.initialDate.month &&
                  _selectedYear == widget.initialDate.year;
              return GestureDetector(
                onTap: () {
                  widget.onSelect(DateTime(_selectedYear, index + 1));
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isCurrent ? AppTheme.primary : AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent ? AppTheme.primary : AppTheme.border,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _months[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
