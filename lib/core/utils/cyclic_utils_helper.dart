/// Mirrors the cycle logic in dailyCycleCheck.js. Keep both in sync —
/// if you change one, change the other, or the app and the daily
/// GitHub Action script will disagree on which cycle a payment belongs to.
class CycleUtils {
  /// Returns the start date of the cycle that [now] currently falls in,
  /// based on the group's own [startDate]. Returns null if the group
  /// hasn't started yet.
  static DateTime? currentCycleStart(DateTime startDate, [DateTime? now]) {
    final today = now ?? DateTime.now();
    if (startDate.isAfter(today)) return null;

    var cycleStart = startDate;
    while (true) {
      final next = DateTime(cycleStart.year, cycleStart.month + 1, cycleStart.day);
      if (next.isAfter(today)) break;
      cycleStart = next;
    }
    return cycleStart;
  }

  /// The identifier stored in Firestore for a cycle, e.g. "2026-08-10".
  /// Must match the format produced by cycleKey() in dailyCycleCheck.js.
  static String cycleKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Convenience: the current cycle key for a group, or null if the
  /// group hasn't started yet.
  static String? currentCycleKeyForGroup(DateTime startDate, [DateTime? now]) {
    final start = currentCycleStart(startDate, now);
    return start == null ? null : cycleKey(start);
  }
}