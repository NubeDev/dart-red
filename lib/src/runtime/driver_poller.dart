import 'dart:async';

/// A single point registration in the poll loop.
///
/// The [key] uniquely identifies the point (typically the node ID).
/// [context] carries protocol-specific data (device ID, object type, register
/// address, etc.) that the [PollReader] callback needs.
/// [onValue] delivers the read result back to the point node.
typedef PollPoint<T> = ({
  String key,
  T context,
  void Function(dynamic value, String status, String? error) onValue,
});

/// Protocol-specific read callback.
///
/// The poller calls this for each registered point on every tick. The
/// implementation performs the actual I/O (BACnet readProperty, Modbus
/// readRegisters, etc.) and returns a [PollResult].
typedef PollReader<T> = Future<PollResult> Function(T context);

/// Result of a single point read.
class PollResult {
  final dynamic value;
  final String status;
  final String? error;

  const PollResult.ok(this.value)
      : status = 'ok',
        error = null;
  const PollResult.stale(this.error)
      : value = null,
        status = 'stale';
  const PollResult.error(this.error)
      : value = null,
        status = 'error';
}

/// Shared periodic poll loop used by protocol driver nodes.
///
/// Owns the timer, generation counter, and point registry. The driver
/// creates a [DriverPoller], registers child points via [addPoint], and
/// the poller calls [reader] for each point on every tick.
///
/// Both BACnet and Modbus drivers use this — protocol differences live
/// entirely in the [PollReader] callback.
class DriverPoller<T> {
  final String driverId;
  final Duration interval;
  final PollReader<T> reader;
  final String _tag;

  final points = <PollPoint<T>>[];
  Timer? _timer;
  int _generation = 0;

  DriverPoller({
    required this.driverId,
    required this.interval,
    required this.reader,
    String? tag,
  }) : _tag = tag ?? 'driver';

  /// Start the periodic poll loop.
  ///
  /// The first poll fires after a short delay (2 s) to give child nodes
  /// time to register. Subsequent ticks fire at [interval].
  void start() {
    _generation++;
    final gen = _generation;

    _timer = Timer.periodic(interval, (_) => _poll(gen));

    // First poll after children have registered
    Future.delayed(const Duration(seconds: 2), () {
      if (_generation == gen) {
        print('$_tag[$driverId]: first poll — ${points.length} point(s)');
        _poll(gen);
      }
    });
  }

  /// Stop the poll loop and clear all registered points.
  void stop() {
    _generation++;
    _timer?.cancel();
    _timer = null;
    points.clear();
  }

  /// Register a point for polling.
  void addPoint(PollPoint<T> point) {
    points.add(point);
  }

  /// Remove a point by key.
  void removePoint(String key) {
    points.removeWhere((p) => p.key == key);
  }

  Future<void> _poll(int gen) async {
    if (_generation != gen) return;
    if (points.isEmpty) {
      print('$_tag[$driverId]: poll skipped — no points');
      return;
    }

    print('$_tag[$driverId]: polling ${points.length} point(s)...');

    for (final point in points) {
      if (_generation != gen) return;

      try {
        final result = await reader(point.context);
        point.onValue(result.value, result.status, result.error);
      } catch (e) {
        point.onValue(null, 'error', e.toString());
      }
    }
  }
}
