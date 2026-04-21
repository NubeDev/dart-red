/// HVAC Schedule Library
///
/// Stateless schedule evaluation with 7-day weekly schedules,
/// date-based exceptions (holidays, overrides), and priority-based merging.
///
/// Ported from Go: internal/libs/schedules
library schedules;

export 'schedule.dart';
export 'weekly.dart';
export 'exceptions.dart';
export 'evaluator.dart';
export 'bulk.dart';
