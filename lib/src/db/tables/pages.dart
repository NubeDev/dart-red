import 'package:drift/drift.dart';

import '../converters.dart';

/// Dashboard pages.
@DataClassName('PageRow')
class Pages extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// UI elements on a page.
@DataClassName('WidgetRow')
class Widgets extends Table {
  TextColumn get id => text()();
  TextColumn get pageId => text().references(Pages, #id)();
  TextColumn get type =>
      text()(); // toggle, slider, label, schedule, gauge
  TextColumn get pointId => text().nullable()();
  TextColumn get scheduleId => text().nullable()();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get config =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
