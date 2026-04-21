import 'package:drift/drift.dart';

@DataClassName('PinnedPageRow')
class PinnedPages extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get locationName => text()();
  TextColumn get nodeId => text()();
  TextColumn get nodeLabel => text()();
  TextColumn get pageId => text().nullable()();
  TextColumn get pageTitle => text().nullable()();
  DateTimeColumn get pinnedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
