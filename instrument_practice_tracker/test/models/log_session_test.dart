import 'package:flutter_test/flutter_test.dart';
import 'package:instrument_practice_tracker/models/log_session.dart';

void main() {
  test('LogSession toMap and fromMap should be consistent', () {
    final session = LogSession(
      id: 1,
      instrument: 'Guitar',
      notes: 'Practice scales',
      audioPath: '/path/audio.m4a',
      durationSeconds: 120,
      createdAt: '2025-01-02', // use your model's correct type
    );

    // Convert to map
    final map = session.toMap();

    // Convert back
    final restored = LogSession.fromMap(map);

    expect(restored.id, session.id);
    expect(restored.instrument, session.instrument);
    expect(restored.notes, session.notes);
    expect(restored.audioPath, session.audioPath);
    expect(restored.durationSeconds, session.durationSeconds);
    expect(restored.createdAt, session.createdAt);
  });
}
