import 'package:drift/drift.dart';

import '../schedules/schedule.dart';
import 'converters.dart';
import 'tables/locations.dart';
import 'tables/pinned_pages.dart';
import 'tables/networks.dart';
import 'tables/devices.dart';
import 'tables/points.dart';
import 'tables/schedules.dart';
import 'tables/alarms.dart';
import 'tables/pages.dart';
import 'tables/point_history.dart';
import 'tables/runtime_flows.dart';
import 'tables/runtime_nodes.dart';
import 'tables/runtime_edges.dart';
import 'tables/runtime_history.dart';
import 'tables/runtime_insights.dart';
import 'daos/location_dao.dart';
import 'daos/pinned_page_dao.dart';
import 'daos/network_dao.dart';
import 'daos/device_dao.dart';
import 'daos/point_dao.dart';
import 'daos/schedule_dao.dart';
import 'daos/alarm_dao.dart';
import 'daos/page_dao.dart';
import 'daos/point_history_dao.dart';
import 'daos/runtime_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Locations,
    PinnedPages,
    Networks,
    Devices,
    Points,
    ScheduleEntries,
    ScheduleBindings,
    Alarms,
    Pages,
    Widgets,
    PointHistory,
    RuntimeFlows,
    RuntimeNodes,
    RuntimeEdges,
    RuntimeHistory,
    RuntimeInsights,
  ],
  daos: [
    LocationDao,
    PinnedPageDao,
    NetworkDao,
    DeviceDao,
    PointDao,
    ScheduleDao,
    AlarmDao,
    PageDao,
    PointHistoryDao,
    RuntimeDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Additive migrations — preserves data across schema bumps.

          // Clean up old tables from pre-v4 schemas
          if (from < 4) {
            for (final t in [
              'bms_networks', 'bms_devices', 'bms_points',
              'bms_schedule_entries', 'bms_schedule_bindings',
              'bms_alarms', 'bms_pages', 'bms_widgets',
              'bms_point_history', 'device_transports', 'topics',
            ]) {
              await m.deleteTable(t);
            }
            await m.createAll();
            return;
          }

          if (from < 5) {
            await m.addColumn(points, points.writeWidget);
          }
          if (from < 6) {
            await m.addColumn(points, points.historyType);
            await m.addColumn(points, points.covThreshold);
            await m.addColumn(points, points.historyIntervalSecs);
          }
          if (from < 7) {
            await m.addColumn(networks, networks.cloudNodeId);
            await m.addColumn(networks, networks.locationId);
            await m.addColumn(devices, devices.cloudNodeId);
          }
          if (from < 8) {
            // Rename brokerHost → host, topicPrefix → prefix, add settings.
            // Single alterTable rebuilds the table with all changes at once.
            await m.alterTable(TableMigration(networks, columnTransformer: {
              networks.host: networks.host,       // drift maps old brokerHost
              networks.prefix: networks.prefix,   // drift maps old topicPrefix
            }));
          }
          if (from < 9) {
            await m.createTable(runtimeFlows);
            await m.createTable(runtimeNodes);
            await m.createTable(runtimeEdges);
          }
          if (from < 10) {
            await m.addColumn(runtimeNodes, runtimeNodes.posX);
            await m.addColumn(runtimeNodes, runtimeNodes.posY);
          }
          if (from < 11) {
            await m.addColumn(runtimeNodes, runtimeNodes.parentId);
          }
          if (from < 12) {
            await m.createTable(runtimeHistory);
          }
          if (from < 13) {
            await m.createTable(runtimeInsights);
          }
          if (from < 14) {
            await m.addColumn(runtimeEdges, runtimeEdges.hidden);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
