import 'package:flutter/material.dart';
import 'package:instrument_practice_tracker/routes.dart' as routes;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';
import 'package:instrument_practice_tracker/providers/session_providers.dart';
import 'package:instrument_practice_tracker/widgets/primary_button.dart';
import 'package:instrument_practice_tracker/utils/date_utils.dart';
import 'package:instrument_practice_tracker/widgets/last_session_card.dart';
import 'package:instrument_practice_tracker/widgets/weekly_chart.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(loadSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.library_music, size: 24),
            SizedBox(width: 6),
            Text("Practice Tracker"),
          ],
        ),
        centerTitle: true,
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          final lastSession = sessions.isNotEmpty ? sessions.first : null;

          // ---- TOTAL practice time
          final totalMinutes = sessions.fold(
            0,
            (sum, s) => sum + (s.durationSeconds / 60).ceil(),
          );

          final hours = totalMinutes ~/ 60;
          final minutes = totalMinutes % 60;

          final totalTimeString = "${hours}Hrs ${minutes}Min";

          // ---- WEEKLY BAR DATA (last 7 days)
          final weeklyMinutes = _computeWeeklyMinutes(sessions);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PrimaryButton(
                  text: "Log New Session",
                  onPressed: () =>
                      Navigator.pushNamed(context, routes.logRoute),
                ),
                const SizedBox(height: 20),

                PrimaryButton(
                  text: "View History",
                  onPressed: () =>
                      Navigator.pushNamed(context, routes.historyRoute),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Total Practice Time",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                Text(
                  totalTimeString,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Weekly Practice Overview",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),

                // Week Date Range
                Text(
                  getCurrentWeekRange(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),

                SizedBox(
                  height: 200,
                  child: WeeklyChart(weeklyMinutes: weeklyMinutes),
                ),
                const SizedBox(height: 30),

                if (lastSession != null) LastSessionCard(session: lastSession),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
      ),
    );
  }

  // ---- WEEKLY SECONDS FUNCTION
  List<int> _computeWeeklyMinutes(List<LogSession> sessions) {
    final now = DateTime.now();
    final result = List<int>.filled(7, 0);

    for (var s in sessions) {
      final dt = DateTime.parse(s.createdAt);

      // Only include sessions from the last 7 days
      final diffDays = now.difference(dt).inDays;
      if (diffDays < 0 || diffDays >= 7) continue;

      // Convert weekday → chart index
      final index = dt.weekday % 7;

      // Convert seconds → minutes (round up)
      final mins = (s.durationSeconds / 60).ceil();

      result[index] += mins;
    }

    return result;
  }
}
