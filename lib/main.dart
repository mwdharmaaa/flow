import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flow/features/transactions/log_options_modal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlowApp());
}

class FlowScrollBehavior extends ScrollBehavior {
  const FlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

class FlowApp extends StatefulWidget {
  const FlowApp({super.key});

  @override
  State<FlowApp> createState() => _FlowAppState();
}

class _FlowAppState extends State<FlowApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _appState.darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp(
          title: 'Flow',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const FlowScrollBehavior(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return Container(
              color: isDark ? AppTheme.darkBgBase : const Color(0xFFE9F0FA),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: child ?? const SizedBox(),
              ),
            );
          },
          home: FlowMainScaffold(state: _appState),
        );
      },
    );
  }
}

class FlowMainScaffold extends StatelessWidget {
  final AppState state;

  const FlowMainScaffold({super.key, required this.state});

  void _openAddTransaction(BuildContext context) {
    LogOptionsModal.show(context, state);
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
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final isSubView = state.currentTabIndex > 3;
        final isDark = state.isDarkMode;

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
        );

        return Scaffold(
          backgroundColor: isDark ? AppTheme.darkBgBase : Colors.white,
          extendBody: true,
          appBar: isSubView
              ? AppBar(
                  backgroundColor: isDark ? AppTheme.darkBgBase : AppTheme.background,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary),
                    onPressed: () => state.setTabIndex(0),
                  ),
                  title: Text(
                    _getSubViewTitle(state.currentTabIndex),
                    style: TextStyle(
                      color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Content layer cached across tab switches with IndexedStack
              IndexedStack(
                index: state.currentTabIndex.clamp(0, 6),
                children: [
                  DashboardScreen(state: state),
                  AnalyticsScreen(state: state),
                  BudgetsScreen(state: state),
                  AccountsScreen(state: state),
                  DebtsScreen(state: state),
                  RecurringScreen(state: state),
                  GoalsScreen(state: state),
                ],
              ),

              // Floating Navigation Bar (isolated with RepaintBoundary)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: RepaintBoundary(
                  child: BottomNavBar(
                    currentIndex: state.currentTabIndex <= 3 ? state.currentTabIndex : 0,
                    onTap: (idx) => state.setTabIndex(idx),
                    onAddTap: () => _openAddTransaction(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
