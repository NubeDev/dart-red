import 'schedule.dart';

/// Weekly schedule evaluation extension on [Schedule].
extension WeeklySchedule on Schedule {
  /// Adds a time range to a specific day of the week.
  ///
  /// [day] uses Dart's DateTime weekday constants (DateTime.monday=1 .. DateTime.sunday=7).
  /// [start] and [stop] are in "HH:MM" format.
  /// Midnight rollover is auto-detected when stop < start.
  void addWeeklyTimeRange(int day, String start, String stop) {
    final s = parseTimeOfDay(start);
    final e = parseTimeOfDay(stop);

    final spansMidnight =
        e.hour < s.hour || (e.hour == s.hour && e.minute < s.minute);

    final tr = TimeRange(
      start: start,
      stop: stop,
      spansMidnight: spansMidnight,
    );

    weekly.putIfAbsent(day, () => []);
    weekly[day]!.add(tr);
  }

  /// Evaluates all weekly schedule entries and returns their status.
  List<ScheduleStatus> checkWeekly() {
    final now = getNow();
    final statuses = <ScheduleStatus>[];

    for (final entry in weekly.entries) {
      for (final tr in entry.value) {
        statuses.addAll(_evaluateWeeklyRange(entry.key, tr, now));
      }
    }

    return statuses;
  }

  /// Returns true if any weekly schedule is currently active.
  bool getWeeklyActive() {
    return checkWeekly().any((s) => s.isActive);
  }

  /// Evaluates a single weekly time range.
  /// Returns 1 status (handles midnight span internally).
  List<ScheduleStatus> _evaluateWeeklyRange(
      int day, TimeRange tr, DateTime now) {
    final s = parseTimeOfDay(tr.start);
    final e = parseTimeOfDay(tr.stop);

    if (!tr.spansMidnight) {
      // Normal case: same day
      var startTime = _getTimeOnWeekday(day, s.hour, s.minute, now);
      var stopTime = _getTimeOnWeekday(day, e.hour, e.minute, now);

      // Adjust to current or next occurrence
      while (stopTime.isBefore(now)) {
        startTime = startTime.add(const Duration(days: 7));
        stopTime = stopTime.add(const Duration(days: 7));
      }

      final isActive = now.isAfter(startTime) && now.isBefore(stopTime);

      var nextStart = startTime;
      var nextStop = stopTime;
      if (now.isAfter(stopTime) || isActive) {
        nextStart = startTime.add(const Duration(days: 7));
        nextStop = stopTime.add(const Duration(days: 7));
      }

      return [
        ScheduleStatus(
          isActive: isActive,
          startDate: startTime,
          endDate: stopTime,
          nextStart: nextStart,
          nextStop: nextStop,
          source: 'weekly',
          priority: priority,
        ),
      ];
    }

    // Midnight rollover case
    final nextDay = day == DateTime.sunday ? DateTime.monday : day + 1;

    var startTime = _getTimeOnWeekday(day, s.hour, s.minute, now);
    var midnightTime = _getTimeOnWeekday(day, 23, 59, now)
        .add(const Duration(seconds: 59));
    var nextDayStart = _getTimeOnWeekday(nextDay, 0, 0, now);
    var stopTime = _getTimeOnWeekday(nextDay, e.hour, e.minute, now);

    // Ensure logical ordering
    if (stopTime.isBefore(startTime)) {
      stopTime = stopTime.add(const Duration(days: 7));
      nextDayStart = nextDayStart.add(const Duration(days: 7));
      midnightTime = midnightTime.add(const Duration(days: 7));
    }

    // Adjust to current or future occurrence
    while (stopTime.isBefore(now)) {
      startTime = startTime.add(const Duration(days: 7));
      midnightTime = midnightTime.add(const Duration(days: 7));
      nextDayStart = nextDayStart.add(const Duration(days: 7));
      stopTime = stopTime.add(const Duration(days: 7));
    }

    // Check if currently active in either period
    final isActivePeriod1 =
        now.isAfter(startTime) && now.isBefore(midnightTime);
    final isActivePeriod2 =
        now.isAfter(nextDayStart) && now.isBefore(stopTime);
    final isActive = isActivePeriod1 || isActivePeriod2;

    // Calculate next transition
    DateTime nextStart;
    DateTime nextStop;
    if (isActive) {
      nextStart = startTime.add(const Duration(days: 7));
      nextStop = stopTime;
    } else if (now.isBefore(startTime)) {
      nextStart = startTime;
      nextStop = stopTime;
    } else {
      nextStart = startTime.add(const Duration(days: 7));
      nextStop = stopTime.add(const Duration(days: 7));
    }

    return [
      ScheduleStatus(
        isActive: isActive,
        startDate: startTime,
        endDate: stopTime,
        nextStart: nextStart,
        nextStop: nextStop,
        source: 'weekly-midnight-span',
        priority: priority,
      ),
    ];
  }

  /// Returns a DateTime for a specific weekday and time of day,
  /// relative to the reference date.
  DateTime _getTimeOnWeekday(
      int day, int hour, int minute, DateTime reference) {
    // Start with reference date at the specified time
    var t = DateTime(
      reference.year,
      reference.month,
      reference.day,
      hour,
      minute,
    );
    if (useUtc) {
      t = DateTime.utc(
        reference.year,
        reference.month,
        reference.day,
        hour,
        minute,
      );
    }

    // Calculate days to add to get to target weekday
    final currentWeekday = reference.weekday; // 1=Monday .. 7=Sunday
    var daysToAdd = day - currentWeekday;

    if (daysToAdd < 0) {
      daysToAdd += 7;
    }

    return t.add(Duration(days: daysToAdd));
  }
}
