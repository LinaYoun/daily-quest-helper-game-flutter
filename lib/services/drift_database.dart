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

class WeeklyQuests extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  IntColumn get progress => integer()();
  IntColumn get target => integer()();
  TextColumn get status => text()();
  TextColumn get iconUrl => text().nullable()();
  TextColumn get rewardUrl => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class StreakQuests extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  IntColumn get progress => integer()();
  IntColumn get target => integer()();
  TextColumn get status => text()();
  TextColumn get iconUrl => text().nullable()();
  TextColumn get rewardUrl => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class StreakStates extends Table {
  IntColumn get id => integer()(); // always 1
  IntColumn get streakDays => integer().withDefault(const Constant(0))();
  TextColumn get lastResetYmd => text().nullable()();
  TextColumn get lastCompletionYmd => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

// Inventory of owned decoration items shown on the main hub
class OwnedItems extends Table {
  IntColumn get id => integer()(); // 1:star, 2:flower, 3:butterfly, 4:bow
  TextColumn get key => text()(); // semantic key for future-proofing
  IntColumn get count => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

// Earned badges table
class Badges extends Table {
  IntColumn get id => integer()(); // e.g., 1 => daily5
  TextColumn get key => text()(); // 'daily5'
  TextColumn get earnedAt => text().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Quests,
    WeeklyQuests,
    StreakQuests,
    StreakStates,
    OwnedItems,
    Badges,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(weeklyQuests);
      }
      if (from < 3) {
        await m.createTable(streakQuests);
      }
      if (from < 4) {
        await m.createTable(streakStates);
      }
      if (from < 5) {
        await m.createTable(ownedItems);
      }
      if (from < 6) {
        await m.createTable(badges);
      }
    },
  );

  // CRUD helpers
  Future<List<Quest>> getAllQuests() async => select(quests).get();
  Future<List<WeeklyQuest>> getAllWeeklyQuests() async =>
      select(weeklyQuests).get();
  Future<List<StreakQuest>> getAllStreakQuests() async =>
      select(streakQuests).get();
  Future<StreakState?> getStreakState() async {
    final rows = await (select(
      streakStates,
    )..where((t) => t.id.equals(1))).get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> upsertQuest(QuestsCompanion data) async {
    await into(quests).insertOnConflictUpdate(data);
  }

  Future<void> upsertWeeklyQuest(WeeklyQuestsCompanion data) async {
    await into(weeklyQuests).insertOnConflictUpdate(data);
  }

  Future<void> upsertStreakQuest(StreakQuestsCompanion data) async {
    await into(streakQuests).insertOnConflictUpdate(data);
  }

  Future<void> upsertStreakState(StreakStatesCompanion data) async {
    await into(streakStates).insertOnConflictUpdate(data);
  }

  // Owned items helpers
  Future<List<OwnedItem>> getAllOwnedItems() async => select(ownedItems).get();

  Future<void> upsertOwnedItem(OwnedItemsCompanion data) async {
    await into(ownedItems).insertOnConflictUpdate(data);
  }

  // Badges helpers
  Future<List<Badge>> getAllBadges() async => select(badges).get();
  Future<void> upsertBadge(BadgesCompanion data) async {
    await into(badges).insertOnConflictUpdate(data);
  }

  Future<void> deleteQuestById(int questId) async {
    await (delete(quests)..where((tbl) => tbl.id.equals(questId))).go();
  }

  Future<void> deleteWeeklyQuestById(int questId) async {
    await (delete(weeklyQuests)..where((tbl) => tbl.id.equals(questId))).go();
  }

  Future<void> deleteStreakQuestById(int questId) async {
    await (delete(streakQuests)..where((tbl) => tbl.id.equals(questId))).go();
  }
}

// Connection is provided by conditional import above
