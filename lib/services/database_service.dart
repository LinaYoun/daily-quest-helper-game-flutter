import 'package:drift/drift.dart' as drift;
import '../models.dart' as domain;
import 'drift_database.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final AppDatabase _db = AppDatabase();

  // Create
  Future<int> insertQuest(domain.Quest quest) async {
    await _db.upsertQuest(
      QuestsCompanion(
        id: drift.Value(quest.id),
        title: drift.Value(quest.title),
        progress: drift.Value(quest.progress),
        target: drift.Value(quest.target),
        status: drift.Value(
          quest.status == domain.QuestStatus.completed
              ? 'completed'
              : 'incomplete',
        ),
        iconUrl: drift.Value(quest.iconUrl),
        rewardUrl: drift.Value(quest.rewardUrl),
      ),
    );
    return quest.id;
  }

  // Read
  Future<List<domain.Quest>> getAllQuests() async {
    final rows = await _db.getAllQuests();
    return rows
        .map(
          (r) => domain.Quest(
            id: r.id,
            title: r.title,
            progress: r.progress,
            target: r.target,
            status: r.status == 'completed'
                ? domain.QuestStatus.completed
                : domain.QuestStatus.incomplete,
            iconUrl: r.iconUrl,
            rewardUrl: r.rewardUrl,
          ),
        )
        .toList();
  }

  // Weekly CRUD
  Future<int> insertWeeklyQuest(domain.Quest quest) async {
    await _db.upsertWeeklyQuest(
      WeeklyQuestsCompanion(
        id: drift.Value(quest.id),
        title: drift.Value(quest.title),
        progress: drift.Value(quest.progress),
        target: drift.Value(quest.target),
        status: drift.Value(
          quest.status == domain.QuestStatus.completed
              ? 'completed'
              : 'incomplete',
        ),
        iconUrl: drift.Value(quest.iconUrl),
        rewardUrl: drift.Value(quest.rewardUrl),
      ),
    );
    return quest.id;
  }

  Future<List<domain.Quest>> getAllWeeklyQuests() async {
    final rows = await _db.getAllWeeklyQuests();
    return rows
        .map(
          (r) => domain.Quest(
            id: r.id,
            title: r.title,
            progress: r.progress,
            target: r.target,
            status: r.status == 'completed'
                ? domain.QuestStatus.completed
                : domain.QuestStatus.incomplete,
            iconUrl: r.iconUrl,
            rewardUrl: r.rewardUrl,
          ),
        )
        .toList();
  }

  Future<int> updateWeeklyQuest(domain.Quest quest) async {
    await _db.upsertWeeklyQuest(
      WeeklyQuestsCompanion(
        id: drift.Value(quest.id),
        title: drift.Value(quest.title),
        progress: drift.Value(quest.progress),
        target: drift.Value(quest.target),
        status: drift.Value(
          quest.status == domain.QuestStatus.completed
              ? 'completed'
              : 'incomplete',
        ),
        iconUrl: drift.Value(quest.iconUrl),
        rewardUrl: drift.Value(quest.rewardUrl),
      ),
    );
    return 1;
  }

  Future<int> deleteWeeklyQuest(int id) async {
    await _db.deleteWeeklyQuestById(id);
    return 1;
  }

  // Streak CRUD
  Future<int> insertStreakQuest(domain.Quest quest) async {
    await _db.upsertStreakQuest(
      StreakQuestsCompanion(
        id: drift.Value(quest.id),
        title: drift.Value(quest.title),
        progress: drift.Value(quest.progress),
        target: drift.Value(quest.target),
        status: drift.Value(
          quest.status == domain.QuestStatus.completed
              ? 'completed'
              : 'incomplete',
        ),
        iconUrl: drift.Value(quest.iconUrl),
        rewardUrl: drift.Value(quest.rewardUrl),
      ),
    );
    return quest.id;
  }

  Future<List<domain.Quest>> getAllStreakQuests() async {
    final rows = await _db.getAllStreakQuests();
    return rows
        .map(
          (r) => domain.Quest(
            id: r.id,
            title: r.title,
            progress: r.progress,
            target: r.target,
            status: r.status == 'completed'
                ? domain.QuestStatus.completed
                : domain.QuestStatus.incomplete,
            iconUrl: r.iconUrl,
            rewardUrl: r.rewardUrl,
          ),
        )
        .toList();
  }

  Future<int> updateStreakQuest(domain.Quest quest) async {
    await _db.upsertStreakQuest(
      StreakQuestsCompanion(
        id: drift.Value(quest.id),
        title: drift.Value(quest.title),
        progress: drift.Value(quest.progress),
        target: drift.Value(quest.target),
        status: drift.Value(
          quest.status == domain.QuestStatus.completed
              ? 'completed'
              : 'incomplete',
        ),
        iconUrl: drift.Value(quest.iconUrl),
        rewardUrl: drift.Value(quest.rewardUrl),
      ),
    );
    return 1;
  }

  Future<int> deleteStreakQuest(int id) async {
    await _db.deleteStreakQuestById(id);
    return 1;
  }

  // Streak state helpers
  Future<(int streakDays, String? lastResetYmd, String? lastCompletionYmd)>
  getStreakState() async {
    final s = await _db.getStreakState();
    if (s == null) return (0, null, null);
    return (s.streakDays, s.lastResetYmd, s.lastCompletionYmd);
  }

  Future<void> setStreakState({
    required int streakDays,
    String? lastResetYmd,
    String? lastCompletionYmd,
  }) async {
    await _db.upsertStreakState(
      StreakStatesCompanion(
        id: drift.Value(1),
        streakDays: drift.Value(streakDays),
        lastResetYmd: drift.Value(lastResetYmd),
        lastCompletionYmd: drift.Value(lastCompletionYmd),
      ),
    );
  }

  Future<domain.Quest?> getQuest(int id) async {
    final list = await _db.getAllQuests();
    final r = list.where((e) => e.id == id).cast<domain.Quest?>();
    return r.isEmpty ? null : r.first;
  }

  // Update
  Future<int> updateQuest(domain.Quest quest) async {
    await _db.upsertQuest(
      QuestsCompanion(
        id: drift.Value(quest.id),
        title: drift.Value(quest.title),
        progress: drift.Value(quest.progress),
        target: drift.Value(quest.target),
        status: drift.Value(
          quest.status == domain.QuestStatus.completed
              ? 'completed'
              : 'incomplete',
        ),
        iconUrl: drift.Value(quest.iconUrl),
        rewardUrl: drift.Value(quest.rewardUrl),
      ),
    );
    return 1;
  }

  // Delete
  Future<int> deleteQuest(int id) async {
    await _db.deleteQuestById(id);
    return 1;
  }

  // Delete all quests
  Future<int> deleteAllQuests() async {
    final all = await _db.getAllQuests();
    for (final q in all) {
      await _db.deleteQuestById(q.id);
    }
    return 1;
  }
}
