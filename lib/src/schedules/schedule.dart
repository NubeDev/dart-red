/// HVAC Schedule Library
///
/// A stateless, synchronous schedule evaluation library ported from Go.
/// Supports 7-day weekly schedules with time ranges, date-based exceptions
/// (holidays, overrides, maintenance), and priority-based schedule merging.
library;

/// Represents a time-of-day range (e.g., "08:00" to "17:00")
class TimeRange {
  final String start; // HH:MM format
  final String stop; // HH:MM format
  final bool spansMidnight; // Auto-detected if stop < start

  const TimeRange({
    required this.start,
    required this.stop,
    this.spansMidnight = false,
  });

  Map<String, dynamic> toJson() => {
        'start': start,
        'stop': stop,
        'spansMidnight': spansMidnight,
      };

  factory TimeRange.fromJson(Map<String, dynamic> json) => TimeRange(
        start: json['start'] as String,
        stop: json['stop'] as String,
        spansMidnight: json['spansMidnight'] as bool? ?? false,
      );
}

/// Represents a date-based exception that overrides weekly schedules
class ExceptionEntry {
  final DateTime start;
  final DateTime stop;
  final int priority; // Higher priority wins if exceptions overlap
  final String type; // "override", "temporary", "holiday", "bulk-override"

  const ExceptionEntry({
    required this.start,
    required this.stop,
    required this.priority,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'stop': stop.toIso8601String(),
        'priority': priority,
        'type': type,
      };

  factory ExceptionEntry.fromJson(Map<String, dynamic> json) =>
      ExceptionEntry(
        start: DateTime.parse(json['start'] as String),
        stop: DateTime.parse(json['stop'] as String),
        priority: json['priority'] as int,
        type: json['type'] as String,
      );
}

/// Represents the current state of a single schedule entry
class ScheduleStatus {
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime nextStart;
  final DateTime nextStop;
  final String source; // "weekly", "exception", "weekly-midnight-span"
  final int priority;

  const ScheduleStatus({
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.nextStart,
    required this.nextStop,
    required this.source,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'nextStart': nextStart.toIso8601String(),
        'nextStop': nextStop.toIso8601String(),
        'source': source,
        'priority': priority,
      };
}

/// Represents the complete evaluated state across all schedules
class ScheduleState {
  final bool isActive;
  final String activeSource; // "local-weekly", "master-exception", etc.
  final DateTime? nextTransition;
  final String currentSchedule;
  final int activePriority;

  const ScheduleState({
    required this.isActive,
    required this.activeSource,
    this.nextTransition,
    required this.currentSchedule,
    required this.activePriority,
  });

  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'activeSource': activeSource,
        'nextTransition': nextTransition?.toIso8601String(),
        'currentSchedule': currentSchedule,
        'activePriority': activePriority,
      };
}

/// Combines weekly and exception status for a single schedule
class CombinedStats {
  final bool weeklyActive;
  final bool exceptionActive;
  final List<ScheduleStatus> weekly;
  final List<ScheduleStatus> exception;
  final int priority;

  const CombinedStats({
    required this.weeklyActive,
    required this.exceptionActive,
    required this.weekly,
    required this.exception,
    required this.priority,
  });
}

/// Dart equivalent of Go's time.Weekday (Monday=1 .. Sunday=7)
/// using DateTime.monday..DateTime.sunday constants.

/// Parsed time-of-day result.
class TimeOfDay {
  final int hour;
  final int minute;
  const TimeOfDay(this.hour, this.minute);
}

/// Parses time strings and returns a [TimeOfDay].
/// Accepts: "HH:MM", "H:MM", "HHMM", "HMM", "HH", "H"
TimeOfDay parseTimeOfDay(String timeStr) {
  final trimmed = timeStr.trim();

  int hour;
  int minute;

  if (trimmed.contains(':')) {
    // HH:MM or H:MM
    final parts = trimmed.split(':');
    hour = int.parse(parts[0]);
    minute = parts.length > 1 ? int.parse(parts[1]) : 0;
  } else {
    // No colon — interpret as HHMM, HMM, HH, or H
    final digits = int.tryParse(trimmed);
    if (digits == null) {
      throw FormatException('Invalid time format: $timeStr');
    }
    if (digits <= 23) {
      // Single or double digit — just hours (e.g. "7" → 07:00, "17" → 17:00)
      hour = digits;
      minute = 0;
    } else {
      // 3-4 digits — HHMM (e.g. "0700" → 07:00, "1730" → 17:30)
      hour = digits ~/ 100;
      minute = digits % 100;
    }
  }

  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
    throw FormatException('Time out of range: $timeStr');
  }
  return TimeOfDay(hour, minute);
}

/// Main schedule configuration.
///
/// Holds a 7-day weekly schedule and a list of date-based exceptions.
/// Evaluation is stateless — call [checkWeekly], [checkExceptions],
/// or [checkCombined] to get the current state at any point in time.
class Schedule {
  String name;
  int priority; // 1=local, 10=master, 20=emergency
  final bool useUtc;
  final String timezone;

  /// Weekly schedule: key is DateTime weekday constant (1=Monday .. 7=Sunday)
  final Map<int, List<TimeRange>> weekly;

  /// Date-based exceptions (sorted by start time)
  final List<ExceptionEntry> exceptions;

  Schedule({
    required this.name,
    this.priority = 1,
    this.useUtc = false,
    this.timezone = '',
    Map<int, List<TimeRange>>? weekly,
    List<ExceptionEntry>? exceptions,
  })  : weekly = weekly ?? {},
        exceptions = exceptions ?? [];

  /// Returns current time in the schedule's timezone.
  /// For simplicity, supports UTC toggle. Named timezone support
  /// would require the `timezone` package.
  DateTime getNow() {
    final now = DateTime.now();
    if (useUtc) return now.toUtc();
    return now;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'priority': priority,
        'useUtc': useUtc,
        'timezone': timezone,
        'weekly': weekly.map(
          (day, ranges) =>
              MapEntry(day.toString(), ranges.map((r) => r.toJson()).toList()),
        ),
        'exceptions': exceptions.map((e) => e.toJson()).toList(),
      };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final weeklyJson = json['weekly'] as Map<String, dynamic>? ?? {};
    final weekly = weeklyJson.map(
      (day, ranges) => MapEntry(
        int.parse(day),
        (ranges as List)
            .map((r) => TimeRange.fromJson(r as Map<String, dynamic>))
            .toList(),
      ),
    );

    final exceptionsJson = json['exceptions'] as List? ?? [];
    final exceptions = exceptionsJson
        .map((e) => ExceptionEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    return Schedule(
      name: json['name'] as String? ?? 'Schedule',
      priority: json['priority'] as int? ?? 1,
      useUtc: json['useUtc'] as bool? ?? false,
      timezone: json['timezone'] as String? ?? '',
      weekly: weekly,
      exceptions: exceptions,
    );
  }
}
