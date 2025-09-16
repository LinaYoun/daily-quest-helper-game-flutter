import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'widgets.dart';
import 'services/database_service.dart';
import 'badge_painters.dart';
import 'owned_item_painters.dart';
import 'dart:convert';

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
  final GlobalKey _paperKey = GlobalKey();
  final GlobalKey _rootKey = GlobalKey();
  bool _showStickerPanel = false;
  Map<int, int> _ownedCounts = const {1: 0, 2: 0, 3: 0, 4: 0};
  List<_StickerPlacement> _stickers = <_StickerPlacement>[];

  static const double _stickerSize = 40.0;
  static const double _panelWidth = 220.0;

  @override
  void initState() {
    super.initState();
    _loadAssets();
    _loadStickersAndCounts();
  }

  Future<void> _loadAssets() async {
    _loadingMessage.value = 'Loading your daily quests...';
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _characterUrl.value = null; // Add local asset if available
    // Load quests from SQLite (works across platforms via main.dart factory)
    try {
      // Ensure daily quests are reset if the date rolled over
      await _db.resetDailyIfNeeded();
      _quests.value = await _db.getAllQuests();
    } catch (_) {
      _quests.value = <Quest>[];
    }
    if (!mounted) return;
    _isLoading.value = false;
  }

  Future<void> _loadStickersAndCounts() async {
    try {
      _ownedCounts = await _db.getOwnedItemCounts();
      final String? raw = await _db.getDailyStickerPlacements();
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        _stickers = list
            .map((e) => _StickerPlacement.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _savePlacements() async {
    final String raw = jsonEncode(_stickers.map((e) => e.toJson()).toList());
    await _db.setDailyStickerPlacements(raw);
  }

  void _toggleStickerPanel() {
    setState(() => _showStickerPanel = !_showStickerPanel);
  }

  void _handleAddStickerFromPanel(int itemId, Offset globalDropPosition) async {
    // Find full-screen overlay area
    final RenderBox? rootBox =
        _rootKey.currentContext?.findRenderObject() as RenderBox?;
    if (rootBox == null) return;
    final Offset rootTopLeft = rootBox.localToGlobal(Offset.zero);
    final Size rootSize = rootBox.size;

    final Offset local = globalDropPosition - rootTopLeft;
    // Center by half sticker size
    final Offset centered = local.translate(
      -_stickerSize / 2,
      -_stickerSize / 2,
    );
    if (centered.dx < 0 ||
        centered.dy < 0 ||
        centered.dx > rootSize.width ||
        centered.dy > rootSize.height) {
      return; // outside
    }
    final double fx = (centered.dx / rootSize.width).clamp(0.0, 1.0);
    final double fy = (centered.dy / rootSize.height).clamp(0.0, 1.0);

    if ((_ownedCounts[itemId] ?? 0) <= 0) return;

    setState(() {
      _stickers.add(
        _StickerPlacement(
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
    final _StickerPlacement s = _stickers[idx];
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
    final _StickerPlacement s = _stickers[idx];
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
    final SizedBox box;
    switch (itemId) {
      case 1:
        box = SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemStarPainter()),
        );
        break;
      case 2:
        box = SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemFlowerPainter()),
        );
        break;
      case 3:
        box = SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemButterflyPainter()),
        );
        break;
      default:
        box = SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: ItemBowPainter()),
        );
        break;
    }
    return box;
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
    final bool? actionDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Stack(
        children: <Widget>[
          DeleteConfirmDialog(
            title: '이 퀘스트를 삭제하시겠습니까?',
            onCancel: () => Navigator.of(context).pop(null),
            onConfirm: () => Navigator.of(context).pop(true),
            onEdit: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );

    if (actionDelete == true) {
      try {
        await _db.deleteQuest(id);
      } catch (_) {}
      _quests.value = await _db.getAllQuests();
      return;
    }

    if (actionDelete == false) {
      final List<Quest> cur = _quests.value;
      final Quest q = cur.firstWhere(
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
      final Map<String, dynamic>? edited = await Navigator.of(context)
          .push<Map<String, dynamic>>(
            MaterialPageRoute<Map<String, dynamic>>(
              builder: (_) => EditQuestScreen(quest: q),
            ),
          );
      if (edited != null) {
        final String? title = edited['title'] as String?;
        final int? target = edited['target'] as int?;
        if (title != null && target != null) {
          final Quest updated = q.copyWith(
            title: title,
            target: target,
            progress: q.progress.clamp(0, target),
          );
          try {
            await _db.updateQuest(updated);
          } catch (_) {}
          _quests.value = await _db.getAllQuests();
        }
      }
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
              key: _rootKey,
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
                                  key: _paperKey,
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
                                          builder: (context, quests, __) =>
                                              Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: QuestGridView(
                                                      quests: quests,
                                                      onComplete:
                                                          _handleCompleteQuest,
                                                      onDelete:
                                                          _handleDeleteQuest,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ),
                                      ),
                                      // Sticker overlay moved to full screen, keep paper content clean
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
                // Full-screen sticker overlay (rendered behind tool panels and badges)
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
                    left: 16 + 56, // next to the ? badge
                    child: _StickerPanel(
                      width: _panelWidth,
                      counts: _ownedCounts,
                      stickerSize: _stickerSize,
                      itemBuilder: (itemId) => Draggable<int>(
                        data: itemId,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildStickerGraphic(
                            itemId,
                            size: _stickerSize,
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: _buildStickerGraphic(
                            itemId,
                            size: _stickerSize,
                          ),
                        ),
                        onDragEnd: (details) {
                          _handleAddStickerFromPanel(itemId, details.offset);
                        },
                        child: _buildStickerGraphic(itemId, size: _stickerSize),
                      ),
                      onClose: _toggleStickerPanel,
                    ),
                  ),
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

class _StickerPanel extends StatelessWidget {
  const _StickerPanel({
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
            _PanelItemRow(
              label: '별 x',
              count: counts[1] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(1),
            ),
            _PanelItemRow(
              label: '화분 x',
              count: counts[2] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(2),
            ),
            _PanelItemRow(
              label: '나비 x',
              count: counts[3] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(3),
            ),
            _PanelItemRow(
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

class _PanelItemRow extends StatelessWidget {
  const _PanelItemRow({
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

@immutable
class _StickerPlacement {
  const _StickerPlacement({
    required this.id,
    required this.itemId,
    required this.fx,
    required this.fy,
  });
  final String id;
  final int itemId;
  final double fx; // 0..1 relative to paper width
  final double fy; // 0..1 relative to paper height

  _StickerPlacement copyWith({
    String? id,
    int? itemId,
    double? fx,
    double? fy,
  }) {
    return _StickerPlacement(
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

  factory _StickerPlacement.fromJson(Map<String, dynamic> m) {
    return _StickerPlacement(
      id: m['id'] as String,
      itemId: m['itemId'] as int,
      fx: (m['fx'] as num).toDouble(),
      fy: (m['fy'] as num).toDouble(),
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
