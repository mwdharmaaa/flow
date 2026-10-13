import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flow/state/app_state.dart';
import 'package:flow/models/account_model.dart';
import 'package:flow/features/accounts/accounts_screen.dart';
import 'package:flow/features/accounts/delete_account_dialog.dart';

void main() {
  group('Wallet Deletion Feature Tests', () {
    late AppState state;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      state = AppState();
      state.accounts.clear();
      state.addAccount(
        AccountModel(
          id: 'acc_main',
          name: 'Main Cash',
          type: 'cash',
          balance: 50000.0,
          colorValue: 0xFF1D61E0,
        ),
      );
      state.addAccount(
        AccountModel(
          id: 'acc_secondary',
          name: 'Secondary Wallet',
          type: 'ewallet',
          balance: 25000.0,
          colorValue: 0xFF10B981,
        ),
      );
    });

    test('deleteAccount removes target wallet when multiple exist', () {
      expect(state.accounts.length, 2);
      expect(state.totalBalance, 75000.0);

      final ok = state.deleteAccount('acc_secondary');
      expect(ok, isTrue);
      expect(state.accounts.length, 1);
      expect(state.accounts.first.id, 'acc_main');
      expect(state.totalBalance, 50000.0);
    });

    test('deleteAccount rejects deletion when only one wallet remains', () {
      state.deleteAccount('acc_secondary');
      expect(state.accounts.length, 1);

      final ok = state.deleteAccount('acc_main');
      expect(ok, isFalse);
      expect(state.accounts.length, 1);
      expect(state.accounts.first.name, 'Main Cash');
    });

    testWidgets('AccountsScreen renders delete button and opens DeleteAccountDialog', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: AccountsScreen(state: state),
        ),
      );

      final deleteIcons = find.byIcon(Icons.delete_outline_rounded);
      expect(deleteIcons, findsNWidgets(2));

      await tester.tap(deleteIcons.last);
      await tester.pumpAndSettle();

      expect(find.byType(DeleteAccountDialog), findsOneWidget);
      expect(find.text('Delete Wallet'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(DeleteAccountDialog),
          matching: find.text('Secondary Wallet'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.descendant(
        of: find.byType(DeleteAccountDialog),
        matching: find.text('Delete'),
      ));
      await tester.pumpAndSettle();

      expect(state.accounts.length, 1);
      expect(find.byType(DeleteAccountDialog), findsNothing);
    });
  });
}
