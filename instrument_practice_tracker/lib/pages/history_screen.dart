import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instrument_practice_tracker/providers/session_providers.dart';
import 'package:instrument_practice_tracker/pages/session_detail_page.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(loadSessionsProvider);

    //  READ the search text
    final searchQuery = ref.watch(historySearchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Session History')),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(child: Text('No practice sessions yet.'));
          }

          //  APPLY FILTER
          final filtered = sessions.where((s) {
            final q = searchQuery.toLowerCase();
            return s.instrument.toLowerCase().contains(q) ||
                   s.notes.toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              //  SEARCH BAR UI
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) => ref
                      .read(historySearchQueryProvider.notifier)
                      .state = value,
                  decoration: InputDecoration(
                    hintText: "Search sessions...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              //  LIST USES FILTERED
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final s = filtered[index];

                    return ListTile(
                      title: Text(
                        s.instrument,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(s.createdAt),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.notes.isNotEmpty ? s.notes : "(No notes)",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SessionDetailPage(session: s),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

// Optional: nicer date strings
String formatDate(String isoString) {
  try {
    final dt = DateTime.parse(isoString);
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  } catch (_) {
    return isoString;
  }
}
