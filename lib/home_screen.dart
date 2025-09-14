import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'widgets.dart';
import 'services/database_service.dart';
import 'badge_painters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<List<Quest>> _quests = ValueNotifier<List<Quest>>(
    <Quest>[],
  );
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<String> _loadingMessage = ValueNotifier<String>(
    'Waking up the hamster...',
  );
  final ValueNotifier<String?> _characterUrl = ValueNotifier<String?>(null);
  final ValueNotifier<CharacterState> _characterState =
      ValueNotifier<CharacterState>(CharacterState.idle);
  final ValueNotifier<RewardInfo?> _activeReward = ValueNotifier<RewardInfo?>(
    null,
  );
  final DatabaseService _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    _loadingMessage.value = 'Loading your daily quests...';
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _characterUrl.value = null; // Add local asset if available
    // Load quests from SQLite (works across platforms via main.dart factory)
    try {
      _quests.value = await _db.getAllQuests();
    } catch (_) {
      _quests.value = <Quest>[];
    }
    if (!mounted) return;
    _isLoading.value = false;
  }

  void _handleCompleteQuest(int id) async {
    final List<Quest> current = _quests.value;
    final int questIndex = current.indexWhere((q) => q.id == id);
    if (questIndex == -1) return;

    final Quest quest = current[questIndex];
    if (quest.status == QuestStatus.completed) return;

    final int newProgress = (quest.progress + 1).clamp(0, quest.target);
    Quest updatedQuest;

    if (newProgress >= quest.target) {
      _activeReward.value = RewardInfo(
        questName: quest.title,
        imageUrl: quest.rewardUrl ?? '',
      );
      _characterState.value = CharacterState.happy;
      Future<void>.delayed(const Duration(seconds: 2)).then((_) {
        if (mounted) _characterState.value = CharacterState.idle;
      });
      updatedQuest = quest.copyWith(
        status: QuestStatus.completed,
        progress: quest.target,
      );
      // Check badge awarding condition
      await _db.updateQuest(updatedQuest);
      final String? badge = await _db.awardBadgeDaily5IfNeeded();
      if (badge != null && mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.35),
          builder: (_) => Stack(
            children: <Widget>[
              BadgeAwardDialog(
                title: '새로운 배지 획득! (daily5)',
                child: CustomPaint(painter: Daily5BadgePainter()),
                onClose: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } else {
      updatedQuest = quest.copyWith(progress: newProgress);
      await _db.updateQuest(updatedQuest);
    }

    // Refresh UI from DB
    _quests.value = await _db.getAllQuests();
  }

  void _handleClaimReward() async {
    final (int itemId, String key) = await _db.addRandomOwnedItem();
    _activeReward.value = null;
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Stack(
        children: <Widget>[
          ItemAwardDialog(
            itemId: itemId,
            itemKey: key,
            onClose: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop('refresh');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteQuest(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('퀘스트 삭제'),
        content: const Text('이 퀘스트를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deleteQuest(id);
      } catch (_) {}
      _quests.value = await _db.getAllQuests();
    }
  }

  void _openRegisterScreen() {
    Navigator.of(context)
        .push<Map<String, dynamic>>(
          MaterialPageRoute<Map<String, dynamic>>(
            builder: (_) => const RegisterQuestScreen(),
          ),
        )
        .then((result) async {
          if (!mounted || result == null) return;
          final String? title = result['title'] as String?;
          final int? target = result['target'] as int?;
          if (title == null || target == null) return;

          // Show creating overlay while generating assets
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.35),
            builder: (_) => const LoadingScreen(message: '일일 임무 생성 중...'),
          );

          final Map<String, String?> assets = await _fetchQuestAssetsForTitle(
            title,
          );

          if (!mounted) return;
          Navigator.of(context).pop(); // close loading overlay

          final List<Quest> before = await _db.getAllQuests();
          final int nextId =
              (before.map((q) => q.id).fold<int>(0, (a, b) => a > b ? a : b)) +
              1;

          final newQuest = Quest(
            id: nextId,
            title: title,
            progress: 0,
            target: target,
            status: QuestStatus.incomplete,
            iconUrl: assets['icon'] ?? kPlaceholderIcon,
            rewardUrl: null, // Always use Flutter-drawn reward icon
          );

          try {
            await _db.insertQuest(newQuest);
          } catch (_) {}
          _quests.value = await _db.getAllQuests();
        });
  }

  Future<Map<String, String?>> _fetchQuestAssetsForTitle(String title) async {
    // Always use Flutter-drawn icons, no external API calls
    return <String, String?>{'icon': null, 'reward': null};
  }

  @override
  Widget build(BuildContext context) {
    // Loading gate
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return ValueListenableBuilder<String>(
            valueListenable: _loadingMessage,
            builder: (context, msg, __) => AbsorbPointer(
              absorbing: true,
              child: LoadingScreen(message: msg),
            ),
          );
        }

        // Render background asset + overlay interactive UI
        return Scaffold(
          backgroundColor: colorBackground,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                // Patterned background similar to reference image (slightly darker so pattern is visible)
                const Positioned.fill(child: PatternBackground()),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ValueListenableBuilder<String?>(
                            valueListenable: _characterUrl,
                            builder: (context, url, __) {
                              if (url == null) return const SizedBox.shrink();
                              return SizedBox(
                                width: 256,
                                height: 256,
                                child: ValueListenableBuilder<CharacterState>(
                                  valueListenable: _characterState,
                                  builder: (context, state, ___) =>
                                      CharacterView(
                                        imageUrl: url,
                                        state: state,
                                      ),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: FractionallySizedBox(
                                widthFactor: 0.88,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorPaper.withOpacity(0.92),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          56,
                                          16,
                                          16,
                                        ),
                                        child:
                                            ValueListenableBuilder<List<Quest>>(
                                              valueListenable: _quests,
                                              builder: (context, quests, __) =>
                                                  SizedBox.expand(
                                                    child: QuestGridView(
                                                      quests: quests,
                                                      onComplete:
                                                          _handleCompleteQuest,
                                                      onDelete:
                                                          _handleDeleteQuest,
                                                    ),
                                                  ),
                                            ),
                                      ),
                                      const HeaderBar(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned(top: 16, left: 16, child: CornerDecoration()),
                Positioned(bottom: 16, left: 16, child: _HomeBadgeButton()),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: TopRightCharacterBadge(),
                ),
                Positioned(
                  right: 20,
                  bottom: 20,
                  child: FloatingActionButton(
                    backgroundColor: colorAccent,
                    foregroundColor: Colors.white,
                    onPressed: _openRegisterScreen,
                    child: const Icon(Icons.add),
                  ),
                ),
                ValueListenableBuilder<RewardInfo?>(
                  valueListenable: _activeReward,
                  builder: (context, reward, __) => reward == null
                      ? const SizedBox.shrink()
                      : RewardDialog(
                          reward: reward,
                          onClaim: _handleClaimReward,
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeBadgeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop('refresh'),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xFFF6EED6),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: const Color(0xFFBE9E6A), width: 6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.home, color: colorText, size: 34),
            SizedBox(height: 2),
            Text(
              'HOME',
              style: TextStyle(
                color: colorText,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
