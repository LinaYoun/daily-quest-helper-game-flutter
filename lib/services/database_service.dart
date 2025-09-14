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
