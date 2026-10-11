import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/models/transaction_model.dart';
import 'package:flow/models/account_model.dart';
import 'package:flow/features/dashboard/dashboard_screen.dart';
import 'package:flow/main.dart';

void main() {
  group('Reactive Clear History Tests', () {
    late AppState state;

    setUp(() {
      state = AppState();
      state.addAccount(
        AccountModel(
          id: 'acc_test',
          name: 'Cash',
          type: 'Wallet',
          balance: 100000.0,
          colorValue: 0xFF1D61E0,
        ),
      );
      state.addTransaction(
        TransactionModel(
          id: 'tx_1',
          type: TransactionType.expense,
          amount: 25000.0,
          accountId: 'acc_test',
          category: 'Food',
          date: DateTime.now(),
          note: 'Kopi',
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    });

    testWidgets('DashboardScreen immediately reacts to clearAllTransactions', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardScreen(state: state),
          ),
        ),
      );

      expect(find.text('Kopi'), findsOneWidget);
      expect(find.text('No transactions yet'), findsNothing);

      state.clearAllTransactions();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Kopi'), findsNothing);
      expect(find.text('No transactions yet'), findsOneWidget);
    });

    testWidgets('FlowMainScaffold IndexedStack immediately reacts to clearAllTransactions', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: FlowMainScaffold(state: state),
        ),
      );

      expect(find.text('Kopi'), findsOneWidget);

      state.clearAllTransactions();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Kopi'), findsNothing);
      expect(find.text('No transactions yet'), findsOneWidget);
    });
  });
}
