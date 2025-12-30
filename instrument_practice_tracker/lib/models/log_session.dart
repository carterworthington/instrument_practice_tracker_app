class LogSession {
  final int? id;
  final String instrument;
  final int durationSeconds;
  final String notes;
  final String? audioPath;
  final String createdAt;

  LogSession({
    this.id,
    required this.instrument,
    required this.durationSeconds,
    required this.notes,
    this.audioPath,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instrument': instrument,
      'durationSeconds': durationSeconds,
      'notes': notes,
      'audioPath': audioPath,
      'createdAt': createdAt,
    };
  }

  factory LogSession.fromMap(Map<String, dynamic> map) {
    return LogSession(
      id: map['id'],
      instrument: map['instrument'],
      durationSeconds: map['durationSeconds'],
      notes: map['notes'],
      audioPath: map['audioPath'],
      createdAt: map['createdAt'],
    );
  }
}
