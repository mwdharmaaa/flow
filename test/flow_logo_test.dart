import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flow/core/widgets/flow_logo.dart';

void main() {
  testWidgets('FlowLogo renders properly with CustomPaint', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FlowLogo(size: 32, backgroundColor: Colors.blue),
        ),
      ),
    );

    expect(find.byType(FlowLogo), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
