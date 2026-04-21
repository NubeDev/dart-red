import 'schedule.dart';
import 'weekly.dart';
import 'exceptions.dart';

/// Combines multiple schedules with priority-based evaluation.
///
/// Exceptions always override weekly schedules.
/// Higher priority schedules are checked first.
class ScheduleEvaluator {
  final List<Schedule> _schedules = [];

  /// Adds a schedule to the evaluator.
  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    _sortByPriority();
  }

  /// Sets the local schedule (priority 1). Replaces any existing priority-1 schedule.
  void setLocalSchedule(Schedule schedule) {
    schedule.priority = 1;
    removeScheduleByPriority(1);
    addSchedule(schedule);
  }

  /// Sets the master schedule (priority 10). Replaces any existing priority-10 schedule.
  void setMasterSchedule(Schedule schedule) {
    schedule.priority = 10;
    removeScheduleByPriority(10);
    addSchedule(schedule);
  }

  /// Removes all schedules with the given priority.
  void removeScheduleByPriority(int priority) {
    _schedules.removeWhere((s) => s.priority == priority);
  }

  /// Sorts schedules by priority (highest first).
  void _sortByPriority() {
    _schedules.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// Returns true if any schedule is currently active.
  bool isActive() => getState().isActive;

  /// Returns the complete evaluated state.
  ///
  /// Evaluation order:
  /// 1. Check all schedules for active exceptions (highest priority first)
  /// 2. If no exceptions, check weekly schedules (highest priority first)
  /// 3. If nothing active, find next transition time
  ScheduleState getState() {
    // Check all schedules for active exceptions (highest priority first)
    for (final schedule in _schedules) {
      final activeEx = schedule.getActiveException();
      if (activeEx != null) {
        return ScheduleState(
          isActive: true,
          activeSource: '${schedule.name}-${activeEx.source}',
          nextTransition: activeEx.nextStop,
          currentSchedule: schedule.name,
          activePriority: activeEx.priority,
        );
      }
    }

    // No active exceptions, check weekly schedules
    for (final schedule in _schedules) {
      final weeklyStatuses = schedule.checkWeekly();
      for (final ws in weeklyStatuses) {
        if (ws.isActive) {
          return ScheduleState(
            isActive: true,
            activeSource: '${schedule.name}-weekly',
            nextTransition: ws.nextStop,
            currentSchedule: schedule.name,
            activePriority: ws.priority,
          );
        }
      }
    }

    // Nothing active, find next transition
    return ScheduleState(
      isActive: false,
      activeSource: 'none',
      nextTransition: getNextTransition(),
      currentSchedule: '',
      activePriority: 0,
    );
  }

  /// Returns the time of the next state change across all schedules.
  DateTime? getNextTransition() {
    DateTime? earliest;

    for (final schedule in _schedules) {
      // Check exceptions
      for (final ex in schedule.checkExceptions()) {
        if (ex.nextStart.millisecondsSinceEpoch > 0) {
          if (earliest == null || ex.nextStart.isBefore(earliest)) {
            earliest = ex.nextStart;
          }
        }
      }

      // Check weekly
      for (final ws in schedule.checkWeekly()) {
        if (ws.nextStart.millisecondsSinceEpoch > 0) {
          if (earliest == null || ws.nextStart.isBefore(earliest)) {
            earliest = ws.nextStart;
          }
        }
      }
    }

    return earliest;
  }

  /// Returns the status of all schedules for debugging/display.
  Map<String, CombinedStats> getAllStatuses() {
    final result = <String, CombinedStats>{};

    for (final schedule in _schedules) {
      final weekly = schedule.checkWeekly();
      final exception = schedule.checkExceptions();

      result[schedule.name] = CombinedStats(
        weeklyActive: weekly.any((s) => s.isActive),
        exceptionActive: exception.any((s) => s.isActive),
        weekly: weekly,
        exception: exception,
        priority: schedule.priority,
      );
    }

    return result;
  }
}
