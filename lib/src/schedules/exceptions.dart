import 'schedule.dart';

/// Exception schedule evaluation extension on [Schedule].
extension ExceptionSchedule on Schedule {
  /// Adds a date/time-based exception to the schedule.
  /// If [exceptionPriority] is 0, defaults to schedule priority + 1.
  void addException(
    DateTime start,
    DateTime stop,
    String exceptionType, [
    int exceptionPriority = 0,
  ]) {
    final p = exceptionPriority == 0 ? priority + 1 : exceptionPriority;

    final ex = ExceptionEntry(
      start: start,
      stop: stop,
      type: exceptionType,
      priority: p,
    );

    exceptions.add(ex);

    // Keep sorted by start time
    exceptions.sort((a, b) => a.start.compareTo(b.start));
  }

  /// Adds an exception from string timestamps ("yyyy-MM-dd HH:mm:ss").
  void addExceptionFromStrings(
    String start,
    String stop,
    String exceptionType, [
    int exceptionPriority = 0,
  ]) {
    var startTime = DateTime.parse(start);
    var stopTime = DateTime.parse(stop);

    if (useUtc) {
      startTime = startTime.toUtc();
      stopTime = stopTime.toUtc();
    }

    addException(startTime, stopTime, exceptionType, exceptionPriority);
  }

  /// Evaluates all exceptions and returns their status.
  List<ScheduleStatus> checkExceptions() {
    final now = getNow();
    return exceptions.map((ex) => _evaluateException(ex, now)).toList();
  }

  /// Evaluates a single exception entry.
  ScheduleStatus _evaluateException(ExceptionEntry ex, DateTime now) {
    final isActive = now.isAfter(ex.start) && now.isBefore(ex.stop);

    // If exception is in the past, clear next times
    DateTime nextStart;
    DateTime nextStop;
    if (now.isAfter(ex.stop)) {
      nextStart = DateTime.fromMillisecondsSinceEpoch(0);
      nextStop = DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      nextStart = ex.start;
      nextStop = ex.stop;
    }

    return ScheduleStatus(
      isActive: isActive,
      startDate: ex.start,
      endDate: ex.stop,
      nextStart: nextStart,
      nextStop: nextStop,
      source: 'exception-${ex.type}',
      priority: ex.priority,
    );
  }

  /// Returns true if any exception is currently active.
  bool getExceptionActive() {
    return checkExceptions().any((s) => s.isActive);
  }

  /// Returns the highest priority active exception, or null.
  ScheduleStatus? getActiveException() {
    final now = getNow();
    ScheduleStatus? active;

    for (final ex in exceptions) {
      final status = _evaluateException(ex, now);
      if (status.isActive) {
        if (active == null || status.priority > active.priority) {
          active = status;
        }
      }
    }

    return active;
  }

  /// Adds a recurring yearly exception (e.g., holidays).
  /// Adds entries for both current year and next year.
  void addYearlyException(
    int month,
    int day,
    String startTime,
    String stopTime,
    String exceptionType,
  ) {
    final now = getNow();
    final year = now.year;

    final s = parseTimeOfDay(startTime);
    final e = parseTimeOfDay(stopTime);

    var start = useUtc
        ? DateTime.utc(year, month, day, s.hour, s.minute)
        : DateTime(year, month, day, s.hour, s.minute);
    var stop = useUtc
        ? DateTime.utc(year, month, day, e.hour, e.minute)
        : DateTime(year, month, day, e.hour, e.minute);

    // If stop is before start, it spans to next day
    if (stop.isBefore(start)) {
      stop = stop.add(const Duration(days: 1));
    }

    // Add for current year and next year
    addException(start, stop, exceptionType, priority + 5);
    addException(
      DateTime(start.year + 1, start.month, start.day, start.hour,
          start.minute),
      DateTime(
          stop.year + 1, stop.month, stop.day, stop.hour, stop.minute),
      exceptionType,
      priority + 5,
    );
  }

  /// Removes exceptions that ended more than [olderThan] ago.
  void cleanOldExceptions(Duration olderThan) {
    final now = getNow();
    final cutoff = now.subtract(olderThan);

    exceptions.removeWhere((ex) => ex.stop.isBefore(cutoff));
  }
}

/// Creates a temporary exception starting now for the given duration.
ExceptionEntry createTemporaryException(Duration duration, int priority) {
  final now = DateTime.now();
  return ExceptionEntry(
    start: now,
    stop: now.add(duration),
    type: 'temporary',
    priority: priority,
  );
}
