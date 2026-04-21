import 'schedule.dart';
import 'exceptions.dart';

/// Bulk schedule operations extension on [Schedule].
extension BulkOperations on Schedule {
  /// Applies a bulk exception to the schedule.
  void applyBulkException(ExceptionEntry ex) {
    addException(ex.start, ex.stop, ex.type, ex.priority);
  }

  /// Creates and applies an exception to turn off for a duration.
  void turnOffForDuration(Duration duration) {
    final ex = createBulkOverride(duration);
    applyBulkException(ex);
  }

  /// Creates and applies a force-on exception for a duration.
  /// Only meaningful if the underlying schedule would be off.
  void turnOnForDuration(Duration duration) {
    final ex = createBulkOverride(duration);
    applyBulkException(ExceptionEntry(
      start: ex.start,
      stop: ex.stop,
      type: 'force-on',
      priority: ex.priority,
    ));
  }

  /// Creates a scheduled downtime period.
  void scheduleDowntime(DateTime start, Duration duration) {
    final ex = createScheduledOverride(start, duration);
    applyBulkException(ExceptionEntry(
      start: ex.start,
      stop: ex.stop,
      type: 'maintenance',
      priority: ex.priority,
    ));
  }

  /// Adds a holiday exception (all day).
  void addHolidayException(String name, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final stop = start.add(const Duration(days: 1));

    applyBulkException(ExceptionEntry(
      start: start,
      stop: stop,
      type: 'holiday-$name',
      priority: 80,
    ));
  }
}

/// Creates a temporary override exception starting now.
ExceptionEntry createBulkOverride(Duration duration, [int priority = 100]) {
  final now = DateTime.now();
  return ExceptionEntry(
    start: now,
    stop: now.add(duration),
    type: 'bulk-override',
    priority: priority,
  );
}

/// Creates an override that starts at a specific time.
ExceptionEntry createScheduledOverride(DateTime start, Duration duration,
    [int priority = 100]) {
  return ExceptionEntry(
    start: start,
    stop: start.add(duration),
    type: 'scheduled-override',
    priority: priority,
  );
}

/// Creates an override for a specific date range.
ExceptionEntry createDateRangeOverride(DateTime start, DateTime stop,
    [int priority = 100]) {
  return ExceptionEntry(
    start: start,
    stop: stop,
    type: 'date-range-override',
    priority: priority,
  );
}

/// Represents a bulk exception for distribution (e.g., via MQTT/NATS).
class BulkExceptionMessage {
  final ExceptionEntry exception;
  final String targetType; // "all", "group", "device"
  final List<String> targetIds;
  final DateTime createdAt;
  final String createdBy;

  BulkExceptionMessage({
    required this.exception,
    required this.targetType,
    required this.targetIds,
    required this.createdBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'exception': exception.toJson(),
        'targetType': targetType,
        'targetIds': targetIds,
        'createdAt': createdAt.toIso8601String(),
        'createdBy': createdBy,
      };

  factory BulkExceptionMessage.fromJson(Map<String, dynamic> json) {
    return BulkExceptionMessage(
      exception:
          ExceptionEntry.fromJson(json['exception'] as Map<String, dynamic>),
      targetType: json['targetType'] as String,
      targetIds: (json['targetIds'] as List).cast<String>(),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
