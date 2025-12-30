import 'package:flutter/material.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';
import 'package:instrument_practice_tracker/utils/date_utils.dart';



class LastSessionCard extends StatelessWidget {
  final LogSession session;

  const LastSessionCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Last Session",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: instrument + duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.instrument,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(session.durationSeconds / 60).ceil()} min",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.notes,
                    style: const TextStyle(
                      fontSize: 14,
                    )
                  )
                ],
              ),

              // Right side: date
              Text(
                formatDate(session.createdAt),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
