import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/widgets/layout/bottom_nav_bar.dart';
import 'package:flow/features/dashboard/dashboard_screen.dart';
import 'package:flow/features/analytics/analytics_screen.dart';
import 'package:flow/features/budgets/budgets_screen.dart';
import 'package:flow/features/accounts/accounts_screen.dart';
import 'package:flow/features/debts/debts_screen.dart';
import 'package:flow/features/recurring/recurring_screen.dart';
import 'package:flow/features/goals/goals_screen.dart';
import 'package:flow/features/transactions/add_transaction_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlowApp());
}

class FlowApp extends StatefulWidget {
  const FlowApp({super.key});

  @override
  State<FlowApp> createState() => _FlowAppState();
}

class _FlowAppState extends State<FlowApp> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Container(
          color: const Color(0xFFE9F0FA),
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: child ?? const SizedBox(),
          ),
        );
      },
      home: FlowMainScaffold(state: _appState),
    );
  }
}

class FlowMainScaffold extends StatelessWidget {
  final AppState state;

  const FlowMainScaffold({super.key, required this.state});

  void _openAddTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddTransactionDialog(
        accounts: state.accounts,
        onSave: (tx) => state.addTransaction(tx),
      ),
    );
  }

  String _getSubViewTitle(int index) {
    switch (index) {
      case 4:
        return 'Debts & Loans';
      case 5:
        return 'Recurring Bills';
      case 6:
        return 'Savings Goals';
      default:
        return 'Flow';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubView = state.currentTabIndex > 3;

    Widget activeView;
    switch (state.currentTabIndex) {
      case 0:
        activeView = DashboardScreen(state: state);
        break;
      case 1:
        activeView = AnalyticsScreen(state: state);
        break;
      case 2:
        activeView = BudgetsScreen(state: state);
        break;
      case 3:
        activeView = AccountsScreen(state: state);
        break;
      case 4:
        activeView = DebtsScreen(state: state);
        break;
      case 5:
        activeView = RecurringScreen(state: state);
        break;
      case 6:
        activeView = GoalsScreen(state: state);
        break;
      default:
        activeView = DashboardScreen(state: state);
    }

    return Scaffold(
      appBar: isSubView
          ? AppBar(
              backgroundColor: AppTheme.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                onPressed: () => state.setTabIndex(0),
              ),
              title: Text(
                _getSubViewTitle(state.currentTabIndex),
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      body: activeView,
      bottomNavigationBar: BottomNavBar(
        currentIndex: state.currentTabIndex <= 3 ? state.currentTabIndex : 0,
        onTap: (idx) => state.setTabIndex(idx),
        onAddTap: () => _openAddTransaction(context),
      ),
    );
  }
}
