import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/device_dao.dart';
import 'daos/location_dao.dart';
import 'daos/pinned_page_dao.dart';
import 'daos/network_dao.dart';
import 'daos/point_dao.dart';
import 'daos/schedule_dao.dart';
import 'daos/alarm_dao.dart';
import 'daos/page_dao.dart';
import 'daos/point_history_dao.dart';
import 'daos/runtime_dao.dart';

/// Must be overridden in [ProviderScope] with the eagerly-opened database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in ProviderScope',
  );
});

// --- Shared DAOs ---

final locationDaoProvider = Provider<LocationDao>((ref) {
  return ref.watch(appDatabaseProvider).locationDao;
});

final pinnedPageDaoProvider = Provider<PinnedPageDao>((ref) {
  return ref.watch(appDatabaseProvider).pinnedPageDao;
});

// --- Core DAOs ---

final networkDaoProvider = Provider<NetworkDao>((ref) {
  return ref.watch(appDatabaseProvider).networkDao;
});

final deviceDaoProvider = Provider<DeviceDao>((ref) {
  return ref.watch(appDatabaseProvider).deviceDao;
});

final pointDaoProvider = Provider<PointDao>((ref) {
  return ref.watch(appDatabaseProvider).pointDao;
});

// --- Automation & UI DAOs ---

final scheduleDaoProvider = Provider<ScheduleDao>((ref) {
  return ref.watch(appDatabaseProvider).scheduleDao;
});

final alarmDaoProvider = Provider<AlarmDao>((ref) {
  return ref.watch(appDatabaseProvider).alarmDao;
});

final pageDaoProvider = Provider<PageDao>((ref) {
  return ref.watch(appDatabaseProvider).pageDao;
});

final pointHistoryDaoProvider = Provider<PointHistoryDao>((ref) {
  return ref.watch(appDatabaseProvider).pointHistoryDao;
});

// --- Runtime DAO ---

final runtimeDaoProvider = Provider<RuntimeDao>((ref) {
  return ref.watch(appDatabaseProvider).runtimeDao;
});
