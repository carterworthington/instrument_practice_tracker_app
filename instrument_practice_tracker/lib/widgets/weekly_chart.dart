import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  final List<int> weeklyMinutes;

  const WeeklyChart({
    super.key,
    required this.weeklyMinutes,
  });

  @override
  Widget build(BuildContext context) {
    const dayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (i) {
        final value = weeklyMinutes[i].toDouble();

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${weeklyMinutes[i]}m",
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),

            Container(
              width: 20,
              height: value * 4, // scale minutes visually
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              dayLabels[i],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );
  }
}
