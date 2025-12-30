import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instrument_practice_tracker/managers/session_db_manager.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';

// searchQuery
final historySearchQueryProvider = StateProvider<String>((ref) => "");

/// 1. DB instance provider
final dbProvider = Provider<LogSessionDbManager>((ref) {
  return LogSessionDbManager.instance;
});

/// 2. List of sessions (in-memory state)
final sessionListProvider = StateProvider<List<LogSession>>((ref) => []);

/// 3. Load sessions from SQLite
final loadSessionsProvider = FutureProvider<List<LogSession>>((ref) async {
  final db = ref.watch(dbProvider);
  final sessions = await db.getSessions();
  
  return sessions.reversed.toList(); // NEW -> OLD
});
