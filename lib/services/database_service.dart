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

  // Weekly auto-reset if week changed
  Future<void> resetWeeklyIfNeeded() async {
    final String? last = await _db.getAppState('lastWeeklyReset');
    final DateTime now = DateTime.now();
    // Monday start of current week
    final DateTime monday = now.subtract(Duration(days: (now.weekday - 1) % 7));
    final DateTime keyDate = DateTime(monday.year, monday.month, monday.day);
    final String currentKey =
        '${keyDate.year.toString().padLeft(4, '0')}-${keyDate.month.toString().padLeft(2, '0')}-${keyDate.day.toString().padLeft(2, '0')}';
    if (last == currentKey) return;
    final weekly = await getAllWeeklyQuests();
    for (final q in weekly) {
      await _db.upsertWeeklyQuest(
        WeeklyQuestsCompanion(
          id: drift.Value(q.id),
          title: drift.Value(q.title),
          progress: const drift.Value(0),
          target: drift.Value(q.target),
          status: drift.Value('incomplete'),
          iconUrl: drift.Value(q.iconUrl),
          rewardUrl: drift.Value(q.rewardUrl),
        ),
      );
    }
    await _db.setAppState('lastWeeklyReset', currentKey);
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

  // Badges API
  Future<List<String>> getEarnedBadges() async {
    final rows = await _db.getAllBadges();
    return rows.map((b) => b.key).toList();
  }

  Future<String?> awardBadgeDaily5IfNeeded() async {
    final earned = await getEarnedBadges();
    if (earned.contains('daily5')) return null;
    final quests = await getAllQuests();
    final int completed = quests.where((q) => q.isCompleted).length;
    if (completed >= 5) {
      await _db.upsertBadge(
        BadgesCompanion(
          id: drift.Value(1),
          key: drift.Value('daily5'),
          earnedAt: drift.Value(DateTime.now().toIso8601String()),
        ),
      );
      return 'daily5';
    }
    return null;
  }

  Future<String?> awardBadgeWeekly3IfNeeded() async {
    final earned = await getEarnedBadges();
    if (earned.contains('weekly3')) return null;
    final weekly = await getAllWeeklyQuests();
    final int completed = weekly.where((q) => q.isCompleted).length;
    if (completed >= 3) {
      await _db.upsertBadge(
        BadgesCompanion(
          id: drift.Value(2),
          key: drift.Value('weekly3'),
          earnedAt: drift.Value(DateTime.now().toIso8601String()),
        ),
      );
      return 'weekly3';
    }
    return null;
  }

  Future<String?> awardBadgeStreak1IfNeeded() async {
    final earned = await getEarnedBadges();
    if (earned.contains('streak1')) return null;
    final (int days, String? _, String? __) = await getStreakState();
    if (days >= 1) {
      await _db.upsertBadge(
        BadgesCompanion(
          id: drift.Value(3),
          key: drift.Value('streak1'),
          earnedAt: drift.Value(DateTime.now().toIso8601String()),
        ),
      );
      return 'streak1';
    }
    return null;
  }

  // Owned items API
  // itemId: 1 star, 2 flower, 3 butterfly, 4 bow
  Future<Map<int, int>> getOwnedItemCounts() async {
    final items = await _db.getAllOwnedItems();
    final Map<int, int> result = {1: 0, 2: 0, 3: 0, 4: 0};
    for (final it in items) {
      result[it.id] = it.count;
    }
    return result;
  }

  Future<(int, String)> addRandomOwnedItem() async {
    final int itemId = (DateTime.now().millisecondsSinceEpoch % 4) + 1;
    String key = 'star';
    if (itemId == 2) key = 'flower';
    if (itemId == 3) key = 'butterfly';
    if (itemId == 4) key = 'bow';
    await _db.upsertOwnedItem(
      OwnedItemsCompanion(
        id: drift.Value(itemId),
        key: drift.Value(key),
        count: drift.Value.absent(),
      ),
    );
    // Read current then increment
    final items = await _db.getAllOwnedItems();
    final existing = items.where((e) => e.id == itemId).toList();
    final int current = existing.isEmpty ? 0 : existing.first.count;
    await _db.upsertOwnedItem(
      OwnedItemsCompanion(
        id: drift.Value(itemId),
        key: drift.Value(key),
        count: drift.Value(current + 1),
      ),
    );
    return (itemId, key);
  }
}
