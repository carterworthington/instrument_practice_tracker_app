import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';
import 'package:instrument_practice_tracker/widgets/last_session_card.dart';

void main() {
  testWidgets('LastSessionCard displays correct session info',
      (WidgetTester tester) async {

    final session = LogSession(
      id: 1,
      instrument: 'Guitar',
      notes: 'Worked on scales',
      audioPath: null,
      durationSeconds: 135, // should show "3 min"
      createdAt: DateTime(2025, 1, 2).toIso8601String(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LastSessionCard(session: session),
        ),
      ),
    );

    // Header
    expect(find.text('Last Session'), findsOneWidget);

    // Instrument
    expect(find.text('Guitar'), findsOneWidget);

    // Duration → 135 seconds = 2.25 min → ceil = 3 min
    expect(find.text('3 min'), findsOneWidget);

    // Notes
    expect(find.text('Worked on scales'), findsOneWidget);

    // Date text — since formatDate() formats the date,
    // we verify it *exists*, not the exact string:
    expect(find.byWidgetPredicate(
      (widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.contains('2025'),
    ), findsOneWidget);
  });
}
