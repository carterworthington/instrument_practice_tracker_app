// date_utils.dart

String formatDate(String isoString) {
  try {
    final dt = DateTime.parse(isoString);
    final year = dt.year;
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return "$year-$month-$day";
  } catch (_) {
    return isoString;
  }
}

String getCurrentWeekRange() {
  final now = DateTime.now();

  // Start of week → Monday
  final monday = now.subtract(Duration(days: now.weekday - 1));

  // End of week → Sunday
  final sunday = monday.add(const Duration(days: 6));

  String fmt(DateTime d) => "${d.month}/${d.day}";

  return "${fmt(monday)} – ${fmt(sunday)}";
}
