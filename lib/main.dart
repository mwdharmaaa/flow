import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/widgets/layout/top_header_bar.dart';
import 'package:flow/widgets/layout/bottom_nav_bar.dart';
import 'package:flow/features/dashboard/dashboard_screen.dart';
import 'package:flow/features/analytics/analytics_screen.dart';
import 'package:flow/features/budgets/budgets_screen.dart';
import 'package:flow/features/accounts/accounts_screen.dart';
import 'package:flow/features/settings/settings_screen.dart';
import 'package:flow/features/debts/debts_screen.dart';
import 'package:flow/features/recurring/recurring_screen.dart';
import 'package:flow/features/goals/goals_screen.dart';

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
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return Container(
          color: const Color(0xFF070A10),
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

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Flow';
      case 1:
        return 'Laporan & Analitik';
      case 2:
        return 'Anggaran Bulanan';
      case 3:
        return 'Dompet & Akun';
      case 4:
        return 'Lainnya & Pengaturan';
      case 5:
        return 'Hutang & Piutang';
      case 6:
        return 'Tagihan Rutin';
      case 7:
        return 'Target Keuangan & Celengan';
      default:
        return 'Flow';
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _getTitle(state.currentTabIndex);

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
        activeView = SettingsScreen(
          state: state,
          onOpenAnalytics: () => state.setTabIndex(1),
          onOpenDebts: () => state.setTabIndex(5),
          onOpenRecurring: () => state.setTabIndex(6),
          onOpenGoals: () => state.setTabIndex(7),
        );
        break;
      case 5:
        activeView = DebtsScreen(state: state);
        break;
      case 6:
        activeView = RecurringScreen(state: state);
        break;
      case 7:
        activeView = GoalsScreen(state: state);
        break;
      default:
        activeView = DashboardScreen(state: state);
    }

    return Scaffold(
      appBar: TopHeaderBar(
        title: title,
        onBack: state.currentTabIndex > 4 ? () => state.setTabIndex(4) : null,
      ),
      body: activeView,
      bottomNavigationBar: BottomNavBar(
        currentIndex: state.currentTabIndex,
        onTap: (idx) => state.setTabIndex(idx),
      ),
    );
  }
}
