import 'package:flutter/material.dart';
import 'constants.dart';
import 'widgets.dart';
import 'models.dart';
import 'services/database_service.dart';
import 'badge_painters.dart';
import 'owned_item_painters.dart';
import 'dart:convert';

class StreakHomeScreen extends StatefulWidget {
  const StreakHomeScreen({super.key});
  @override
  State<StreakHomeScreen> createState() => _StreakHomeScreenState();
}

class _StreakHomeScreenState extends State<StreakHomeScreen> {
  final DatabaseService _db = DatabaseService();
  final ValueNotifier<List<Quest>> _quests = ValueNotifier<List<Quest>>(
    <Quest>[],
  );
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<RewardInfo?> _activeReward = ValueNotifier<RewardInfo?>(
    null,
  );

  // Sticker state (streak)
  final GlobalKey _rootKey = GlobalKey();
  bool _showStickerPanel = false;
  Map<int, int> _ownedCounts = const {1: 0, 2: 0, 3: 0, 4: 0};
  List<_StreakStickerPlacement> _stickers = <_StreakStickerPlacement>[];
  static const double _stickerSize = 40.0;

  @override
  void initState() {
    super.initState();
    _load();
    _loadStickersAndCounts();
    _db.ensurePlayerStateInitialized();
  }

  Future<void> _load() async {
    final items = await _db.getAllStreakQuests();
    _quests.value = items;
    // Auto-reset daily progress when date changed
    final now = DateTime.now();
    final String today =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final (int streakDays, String? lastResetYmd, String? lastCompletionYmd) =
        await _db.getStreakState();
    if (lastResetYmd != today) {
      final bool hasQuests = items.isNotEmpty;
      final bool allCompletedYesterday =
          hasQuests && items.every((q) => q.status == QuestStatus.completed);
      final int nextStreakDays = allCompletedYesterday ? streakDays : 0;
      for (final q in items) {
        if (q.progress != 0 || q.status == QuestStatus.completed) {
          await _db.updateStreakQuest(
            q.copyWith(progress: 0, status: QuestStatus.incomplete),
          );
        }
      }
      await _db.setStreakState(
        streakDays: nextStreakDays,
        lastResetYmd: today,
        lastCompletionYmd: lastCompletionYmd,
      );
      _quests.value = await _db.getAllStreakQuests();
    }
    _isLoading.value = false;
  }

  Future<void> _loadStickersAndCounts() async {
    try {
      _ownedCounts = await _db.getOwnedItemCounts();
      final String? raw = await _db.getStreakStickerPlacements();
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        _stickers = list
            .map(
              (e) =>
                  _StreakStickerPlacement.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _savePlacements() async {
    final String raw = jsonEncode(_stickers.map((e) => e.toJson()).toList());
    await _db.setStreakStickerPlacements(raw);
  }

  void _toggleStickerPanel() {
    setState(() => _showStickerPanel = !_showStickerPanel);
  }

  void _handleAddStickerFromPanel(int itemId, Offset globalDropPosition) async {
    final RenderBox? rootBox =
        _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rootBox == null) return;
    final Offset topLeft = rootBox.localToGlobal(Offset.zero);
    final Size rootSize = rootBox.size;

    final Offset local = globalDropPosition - topLeft;
    final Offset centered = local.translate(
      -_stickerSize / 2,
      -_stickerSize / 2,
    );
    if (centered.dx < 0 ||
        centered.dy < 0 ||
        centered.dx > rootSize.width ||
        centered.dy > rootSize.height) {
      return;
    }
    final double fx = (centered.dx / rootSize.width).clamp(0.0, 1.0);
    final double fy = (centered.dy / rootSize.height).clamp(0.0, 1.0);

    if ((_ownedCounts[itemId] ?? 0) <= 0) return;

    setState(() {
      _stickers.add(
        _StreakStickerPlacement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          itemId: itemId,
          fx: fx,
          fy: fy,
        ),
      );
      _ownedCounts[itemId] = (_ownedCounts[itemId] ?? 0) - 1;
    });
    await _db.decrementOwnedItem(itemId);
    await _savePlacements();
  }

  void _moveSticker(String id, Offset delta, Size rootSize) {
    final int idx = _stickers.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    final _StreakStickerPlacement s = _stickers[idx];
    final double nx = (s.fx * rootSize.width + delta.dx) / rootSize.width;
    final double ny = (s.fy * rootSize.height + delta.dy) / rootSize.height;
    setState(() {
      _stickers[idx] = s.copyWith(
        fx: nx.clamp(0.0, 1.0),
        fy: ny.clamp(0.0, 1.0),
      );
    });
    _savePlacements();
  }

  Future<void> _deleteSticker(String id) async {
    final int idx = _stickers.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    final _StreakStickerPlacement s = _stickers[idx];
    final bool? ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Stack(
        children: <Widget>[
          DeleteConfirmDialog(
            title: '이 스티커를 삭제할까요?',
            onCancel: () => Navigator.of(context).pop(false),
            onConfirm: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() {
      _stickers.removeAt(idx);
      _ownedCounts[s.itemId] = (_ownedCounts[s.itemId] ?? 0) + 1;
    });
    await _db.incrementOwnedItem(s.itemId);
    await _savePlacements();
  }

  Widget _buildStickerGraphic(int itemId, {double size = _stickerSize}) {
    switch (itemId) {
      case 1:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemStarPainter()),
        );
      case 2:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemFlowerPainter()),
        );
      case 3:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemButterflyPainter()),
        );
      default:
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemBowPainter()),
        );
    }
  }

  void _handleClaimReward() async {
    final (int itemId, String key) = await DatabaseService()
        .addRandomOwnedItem();
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

  Future<void> _openRegister() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const StreakRegisterScreen()),
    );
    if (!mounted || result == null) return;
    final String? title = result['title'] as String?;
    final int? target = result['target'] as int?;
    if (title == null || target == null) return;

    final List<Quest> before = await _db.getAllStreakQuests();
    final int nextId =
        (before.map((q) => q.id).fold<int>(0, (a, b) => a > b ? a : b)) + 1;

    await _db.insertStreakQuest(
      Quest(
        id: nextId,
        title: title,
        progress: 0,
        target: target,
        status: QuestStatus.incomplete,
        iconUrl: 'builtin:streak-chain',
      ),
    );
    _quests.value = await _db.getAllStreakQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Stack(
          key: _rootKey,
          children: <Widget>[
            const Positioned.fill(child: PatternBackground()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                              child: ValueListenableBuilder<List<Quest>>(
                                valueListenable: _quests,
                                builder: (context, quests, _) => Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: QuestGridView(
                                        quests: quests,
                                        emptyMessage: '연속 임무를 등록하세요',
                                    onDelete: (id) async {
                                      final bool? actionDelete =
                                          await showDialog<bool>(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor: Colors.black
                                                .withOpacity(0.35),
                                            builder: (_) => Stack(
                                              children: <Widget>[
                                                DeleteConfirmDialog(
                                                  title: '이 연속 임무를 삭제하시겠습니까?',
                                                  onCancel: () => Navigator.of(
                                                    context,
                                                  ).pop(null),
                                                  onConfirm: () => Navigator.of(
                                                    context,
                                                  ).pop(true),
                                                  onEdit: () => Navigator.of(
                                                    context,
                                                  ).pop(false),
                                                ),
                                              ],
                                            ),
                                          );
                                      if (actionDelete == true) {
                                        await _db.deleteStreakQuest(id);
                                        _quests.value = await _db
                                            .getAllStreakQuests();
                                        return;
                                      }
                                      if (actionDelete == false) {
                                        final List<Quest> current =
                                            _quests.value;
                                        final Quest q = current.firstWhere(
                                          (e) => e.id == id,
                                          orElse: () => const Quest(
                                            id: -1,
                                            title: '',
                                            progress: 0,
                                            target: 1,
                                            status: QuestStatus.incomplete,
                                            iconUrl: null,
                                            rewardUrl: null,
                                          ),
                                        );
                                        if (q.id == -1) return;
                                        final Map<String, dynamic>? edited =
                                            await Navigator.of(
                                              context,
                                            ).push<Map<String, dynamic>>(
                                              MaterialPageRoute<
                                                Map<String, dynamic>
                                              >(
                                                builder: (_) =>
                                                    EditQuestScreen(quest: q),
                                              ),
                                            );
                                        if (edited != null) {
                                          final String? title =
                                              edited['title'] as String?;
                                          final int? target =
                                              edited['target'] as int?;
                                          if (title != null && target != null) {
                                            final Quest updated = q.copyWith(
                                              title: title,
                                              target: target,
                                              progress: q.progress.clamp(
                                                0,
                                                target,
                                              ),
                                            );
                                            await _db.updateStreakQuest(
                                              updated,
                                            );
                                            _quests.value = await _db
                                                .getAllStreakQuests();
                                          }
                                        }
                                      }
                                    },
                                    onComplete: (id) async {
                                      final List<Quest> current = await _db
                                          .getAllStreakQuests();
                                      final Quest q = current.firstWhere(
                                        (e) => e.id == id,
                                      );
                                      if (q.status == QuestStatus.completed) {
                                        return;
                                      }
                                      final int newProgress = (q.progress + 1)
                                          .clamp(0, q.target);
                                      if (newProgress >= q.target) {
                                        _activeReward.value = RewardInfo(
                                          questName: q.title,
                                          imageUrl: q.rewardUrl ?? '',
                                        );
                                      }
                                      final updated = q.copyWith(
                                        progress: newProgress,
                                        status: newProgress >= q.target
                                            ? QuestStatus.completed
                                            : q.status,
                                      );
                                      await _db.updateStreakQuest(updated);
                                      if (newProgress >= q.target) {
                                        final (
                                          int newLevel,
                                          int newXp,
                                          bool leveledUp,
                                        ) = await _db.awardXp(
                                          kXpPerQuestCompletion,
                                        );
                                        if (leveledUp && mounted) {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor: Colors.black
                                                .withOpacity(0.35),
                                            builder: (_) => Stack(
                                              children: <Widget>[
                                                BadgeAwardDialog(
                                                  title: '레벨 업! Lv.$newLevel',
                                                  child: CustomPaint(
                                                    painter: AwardStarPainter(),
                                                  ),
                                                  onClose: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      final after = await _db
                                          .getAllStreakQuests();
                                      final bool hasQuestsToday =
                                          after.isNotEmpty;
                                      final bool allCompletedToday =
                                          hasQuestsToday &&
                                          after.every(
                                            (e) =>
                                                e.status ==
                                                QuestStatus.completed,
                                          );

                                      final now = DateTime.now();
                                      final String today =
                                          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                                      final (
                                        int streakDays,
                                        String? lastResetYmd,
                                        String? lastCompletionYmd,
                                      ) = await _db
                                          .getStreakState();

                                      if (allCompletedToday) {
                                        final bool notCountedYet =
                                            lastCompletionYmd != today;
                                        final int nextStreak = notCountedYet
                                            ? (streakDays + 1)
                                            : streakDays;
                                        await _db.setStreakState(
                                          streakDays: nextStreak,
                                          lastResetYmd: lastResetYmd ?? today,
                                          lastCompletionYmd: today,
                                        );
                                      }
                                      await DatabaseService()
                                          .awardBadgeStreak1IfNeeded();
                                      if (mounted) {
                                        final earned = await DatabaseService()
                                            .getEarnedBadges();
                                        if (earned.contains('streak1')) {
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor: Colors.black
                                                .withOpacity(0.35),
                                            builder: (_) => Stack(
                                              children: <Widget>[
                                                BadgeAwardDialog(
                                                  title: '새로운 배지 획득! (streak1)',
                                                  child: CustomPaint(
                                                    painter:
                                                        Streak1BadgePainter(),
                                                  ),
                                                  onClose: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      _quests.value = await _db
                                          .getAllStreakQuests();
                                      if (mounted) setState(() {});
                                    },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const HeaderBar(title: '연속 임무', showTimer: false),
                            Positioned(
                              top: 8,
                              right: 12,
                              child: FutureBuilder<(int, int, int)>(
                                future: _db.getPlayerLevelState(),
                                builder: (context, snapshot) {
                                  final int level = snapshot.data?.$1 ?? 1;
                                  final int xp = snapshot.data?.$2 ?? 0;
                                  final int need = snapshot.data?.$3 ?? 100;
                                  return LevelChip(
                                    level: level,
                                    xp: xp,
                                    need: need,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Sticker overlay behind panels
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final Size rootSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return Stack(
                    children: _stickers.map((s) {
                      final double left = s.fx * rootSize.width;
                      final double top = s.fy * rootSize.height;
                      return Positioned(
                        left: left,
                        top: top,
                        child: GestureDetector(
                          onPanUpdate: (d) =>
                              _moveSticker(s.id, d.delta, rootSize),
                          onLongPress: () => _deleteSticker(s.id),
                          child: _buildStickerGraphic(s.itemId),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: _toggleStickerPanel,
                child: const CornerDecoration(),
              ),
            ),
            if (_showStickerPanel)
              Positioned(
                top: 16,
                left: 16 + 56,
                child: StreakStickerPanel(
                  width: 220,
                  counts: _ownedCounts,
                  stickerSize: _stickerSize,
                  itemBuilder: (itemId) => Draggable<int>(
                    data: itemId,
                    feedback: Material(
                      color: Colors.transparent,
                      child: _buildStickerGraphic(itemId, size: _stickerSize),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.4,
                      child: _buildStickerGraphic(itemId, size: _stickerSize),
                    ),
                    onDragEnd: (details) {
                      _handleAddStickerFromPanel(itemId, details.offset);
                    },
                    child: _buildStickerGraphic(itemId, size: _stickerSize),
                  ),
                  onClose: _toggleStickerPanel,
                ),
              ),
            Positioned(
              bottom: 16,
              left: 16,
              child: GestureDetector(
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
                    border: Border.all(
                      color: const Color(0xFFBE9E6A),
                      width: 6,
                    ),
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
              ),
            ),
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
                onPressed: _openRegister,
                child: const Icon(Icons.add),
              ),
            ),
            ValueListenableBuilder<RewardInfo?>(
              valueListenable: _activeReward,
              builder: (context, reward, __) => reward == null
                  ? const SizedBox.shrink()
                  : RewardDialog(reward: reward, onClaim: _handleClaimReward),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakRegisterScreen extends StatefulWidget {
  const StreakRegisterScreen({super.key});
  @override
  State<StreakRegisterScreen> createState() => _StreakRegisterScreenState();
}

class _StreakRegisterScreenState extends State<StreakRegisterScreen> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _target = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: PatternBackground()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                24,
                                74,
                                24,
                                24,
                              ),
                              child: const SingleChildScrollView(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                child: _StreakForm(),
                              ),
                            ),
                            const HeaderBar(
                              title: '연속 임무 등록',
                              showTimer: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(top: 16, left: 16, child: CornerDecoration()),
            const Positioned(
              top: 12,
              right: 12,
              child: TopRightCharacterBadge(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakForm extends StatefulWidget {
  const _StreakForm();
  @override
  State<_StreakForm> createState() => _StreakFormState();
}

class _StreakFormState extends State<_StreakForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _target = TextEditingController(text: '1');

  @override
  void dispose() {
    _title.dispose();
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          Row(
            children: const <Widget>[
              Icon(Icons.edit, color: colorText),
              SizedBox(width: 8),
              Text(
                '새 연속 임무 정보를 입력하세요',
                style: TextStyle(
                  color: colorText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PaperField(
            label: '제목',
            child: TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '예: 연속 공부',
              ),
              style: const TextStyle(
                color: colorText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '제목을 입력하세요' : null,
            ),
          ),
          const SizedBox(height: 12),
          _PaperField(
            label: '목표 수치',
            child: TextFormField(
              controller: _target,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '예: 1',
              ),
              style: const TextStyle(
                color: colorText,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              validator: (v) =>
                  (int.tryParse(v ?? '') == null) ? '숫자를 입력하세요' : null,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: colorText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 6,
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final String title = _title.text.trim();
                    final int target = int.parse(_target.text.trim());
                    Navigator.of(
                      context,
                    ).pop(<String, dynamic>{'title': title, 'target': target});
                  }
                },
                child: const Text(
                  '등록',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}

class _PaperField extends StatelessWidget {
  const _PaperField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(color: colorText, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        CustomPaint(
          painter: const DashedRRectPainter(
            strokeColor: kCardStroke,
            fillColor: kCardFill,
            radius: 18,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: child,
          ),
        ),
      ],
    );
  }
}

@immutable
class _StreakStickerPlacement {
  const _StreakStickerPlacement({
    required this.id,
    required this.itemId,
    required this.fx,
    required this.fy,
  });
  final String id;
  final int itemId;
  final double fx;
  final double fy;

  _StreakStickerPlacement copyWith({
    String? id,
    int? itemId,
    double? fx,
    double? fy,
  }) {
    return _StreakStickerPlacement(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      fx: fx ?? this.fx,
      fy: fy ?? this.fy,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'itemId': itemId,
    'fx': fx,
    'fy': fy,
  };

  factory _StreakStickerPlacement.fromJson(Map<String, dynamic> m) {
    return _StreakStickerPlacement(
      id: m['id'] as String,
      itemId: m['itemId'] as int,
      fx: (m['fx'] as num).toDouble(),
      fy: (m['fy'] as num).toDouble(),
    );
  }
}

class StreakStickerPanel extends StatelessWidget {
  const StreakStickerPanel({
    super.key,
    required this.width,
    required this.counts,
    required this.stickerSize,
    required this.itemBuilder,
    required this.onClose,
  });
  final double width;
  final Map<int, int> counts;
  final double stickerSize;
  final Widget Function(int itemId) itemBuilder;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const DashedRRectPainter(
        strokeColor: kCardStroke,
        fillColor: kCardFill,
        radius: 18,
      ),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  '스티커 붙이기',
                  style: TextStyle(
                    color: colorText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _StreakPanelItemRow(
              label: '별 x',
              count: counts[1] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(1),
            ),
            _StreakPanelItemRow(
              label: '화분 x',
              count: counts[2] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(2),
            ),
            _StreakPanelItemRow(
              label: '나비 x',
              count: counts[3] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(3),
            ),
            _StreakPanelItemRow(
              label: '리본 x',
              count: counts[4] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(4),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 4,
                  minimumSize: const Size(64, 32),
                ),
                onPressed: onClose,
                child: const Text(
                  '닫기',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakPanelItemRow extends StatelessWidget {
  const _StreakPanelItemRow({
    required this.label,
    required this.count,
    required this.stickerSize,
    required this.child,
  });
  final String label;
  final int count;
  final double stickerSize;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: count > 0 ? 1.0 : 0.4,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 60,
            child: Text(
              '$label$count',
              style: const TextStyle(
                color: colorText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: stickerSize, height: stickerSize, child: child),
        ],
      ),
    );
  }
}
