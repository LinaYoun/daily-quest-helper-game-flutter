import 'package:drift/drift.dart';
// no-op
import 'drift_connection_web.dart'
    if (dart.library.io) 'drift_connection_native.dart';

part 'drift_database.g.dart';

class Quests extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  IntColumn get progress => integer()();
  IntColumn get target => integer()();
  TextColumn get status => text()(); // 'incomplete' | 'completed'
  TextColumn get iconUrl => text().nullable()();
  TextColumn get rewardUrl => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [Quests])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD helpers
  Future<List<Quest>> getAllQuests() async => select(quests).get();

  Future<void> upsertQuest(QuestsCompanion data) async {
    await into(quests).insertOnConflictUpdate(data);
  }

  Future<void> deleteQuestById(int questId) async {
    await (delete(quests)..where((tbl) => tbl.id.equals(questId))).go();
  }
}

// Connection is provided by conditional import above
