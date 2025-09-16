import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'constants.dart';
import 'home_screen.dart';
import 'widgets.dart';
import 'models.dart';
import 'services/database_service.dart';
import 'weekly_screens.dart';
import 'streak_screens.dart';
import 'services/background_audio_service.dart';
import 'owned_item_painters.dart';
import 'dart:convert';

class MainHubScreen extends StatefulWidget {
  const MainHubScreen({super.key});
  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen> {
  final DatabaseService _db = DatabaseService();
  int _total = 0;
  int _completed = 0;
  int _weeklyTotal = 0;
  int _weeklyCompleted = 0;
  int _streakDays = 0; // TODO: compute real streak when available
  Map<int, int> _ownedCounts = const {1: 0, 2: 0, 3: 0, 4: 0};

  // Sticker state (home)
  final GlobalKey _rootKey = GlobalKey();
  bool _showStickerPanel = false;
  List<_HomeStickerPlacement> _stickers = <_HomeStickerPlacement>[];
  static const double _stickerSize = 40.0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
    _loadStickersAndCounts();
  }

  Future<void> _loadCounts() async {
    try {
      // Ensure daily quests are reset when the app opens or returns here
      await _db.resetDailyIfNeeded();
      final List<Quest> quests = await _db.getAllQuests();
      final List<Quest> weekly = await _db.getAllWeeklyQuests();
      final (int streakDays, String? lastResetYmd, String? lastCompletionYmd) =
          await _db.getStreakState();
      final Map<int, int> owned = await _db.getOwnedItemCounts();
      final int completed = quests.where((q) => q.isCompleted).length;
      final int wCompleted = weekly.where((q) => q.isCompleted).length;
      setState(() {
        _total = quests.length;
        _completed = completed;
        _weeklyTotal = weekly.length;
        _weeklyCompleted = wCompleted;
        _streakDays = streakDays;
        _ownedCounts = owned;
      });
    } catch (_) {
      setState(() {
        _total = 0;
        _completed = 0;
        _weeklyTotal = 0;
        _weeklyCompleted = 0;
        _streakDays = 0;
        _ownedCounts = const {1: 0, 2: 0, 3: 0, 4: 0};
      });
    }
  }

  Future<void> _loadStickersAndCounts() async {
    try {
      _ownedCounts = await _db.getOwnedItemCounts();
      final String? raw = await _db.getHomeStickerPlacements();
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        _stickers = list
            .map(
              (e) => _HomeStickerPlacement.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _savePlacements() async {
    final String raw = jsonEncode(_stickers.map((e) => e.toJson()).toList());
    await _db.setHomeStickerPlacements(raw);
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
        _HomeStickerPlacement(
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
    final _HomeStickerPlacement s = _stickers[idx];
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
    final _HomeStickerPlacement s = _stickers[idx];
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

  Future<void> _openDaily(BuildContext context) async {
    await BackgroundAudioService().initializeAndPlay();
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
    if (result == 'refresh') {
      _loadCounts();
    }
  }

  void _openWeekly(BuildContext context) {
    BackgroundAudioService().initializeAndPlay();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const WeeklyHomeScreen()))
        .then((result) {
          if (result == 'refresh') {
            _loadCounts();
          }
        });
  }

  void _openStreak(BuildContext context) {
    BackgroundAudioService().initializeAndPlay();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const StreakHomeScreen()))
        .then((result) {
          if (result == 'refresh') {
            _loadCounts();
          }
        });
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
                                64,
                                16,
                                16,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    _MissionRow(
                                      onTapDaily: () => _openDaily(context),
                                      onTapWeekly: () => _openWeekly(context),
                                      onTapStreak: () => _openStreak(context),
                                      dailySubtitle: '$_completed/$_total',
                                      weeklySubtitle:
                                          '$_weeklyCompleted/$_weeklyTotal',
                                      streakSubtitle: 'Day $_streakDays',
                                    ),
                                    const SizedBox(height: 24),
                                    _OwnedItemsSection(counts: _ownedCounts),
                                  ],
                                ),
                              ),
                            ),
                            const HeaderBar(
                              title: 'Routine Helper',
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
            // Sticker overlay behind panels and badges
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
                child: HomeStickerPanel(
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

class _MissionRow extends StatelessWidget {
  const _MissionRow({
    required this.onTapDaily,
    required this.onTapWeekly,
    required this.onTapStreak,
    required this.dailySubtitle,
    required this.weeklySubtitle,
    required this.streakSubtitle,
  });
  final VoidCallback onTapDaily;
  final VoidCallback onTapWeekly;
  final VoidCallback onTapStreak;
  final String dailySubtitle;
  final String weeklySubtitle;
  final String streakSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _MissionTile(
            title: '일일 임무',
            subtitle: dailySubtitle,
            onTap: onTapDaily,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MissionTile(
            title: '주간 임무',
            subtitle: weeklySubtitle,
            onTap: onTapWeekly,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _MissionTile(
            title: '연속 임무',
            subtitle: streakSubtitle,
            onTap: onTapStreak,
          ),
        ),
      ],
    );
  }
}

class _MissionTile extends StatelessWidget {
  const _MissionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: const DashedRRectPainter(
          strokeColor: kCardStroke,
          fillColor: kCardFill,
          radius: kQuestCardRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: colorText,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: kChipFillAlt,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: colorText,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OwnedItemsSection extends StatelessWidget {
  const _OwnedItemsSection({required this.counts});
  final Map<int, int> counts;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: const <Widget>[
            Icon(Icons.brush, color: colorText),
            SizedBox(width: 8),
            Text(
              '가진 꾸미기 아이템',
              style: TextStyle(
                color: colorText,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.78,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: <Widget>[
            _ItemCard(
              graphic: SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(painter: _StarItemPainter()),
              ),
              label: 'x${counts[1] ?? 0}',
              iconSize: 140,
            ),
            _ItemCard(
              graphic: SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(painter: _FlowerItemPainter()),
              ),
              label: 'x${counts[2] ?? 0}',
              iconSize: 140,
            ),
            _ItemCard(
              graphic: SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(painter: _ButterflyItemPainter()),
              ),
              label: 'x${counts[3] ?? 0}',
              iconSize: 140,
            ),
            _ItemCard(
              graphic: SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(painter: _BowItemPainter()),
              ),
              label: 'x${counts[4] ?? 0}',
              iconSize: 140,
            ),
          ],
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    this.icon,
    this.graphic,
    required this.label,
    this.iconSize = 44,
  }) : assert(
         icon != null || graphic != null,
         'Either icon or graphic must be provided',
       );
  final IconData? icon;
  final Widget? graphic;
  final String label;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const DashedRRectPainter(
        strokeColor: kCardStroke,
        fillColor: kCardFill,
        radius: kQuestCardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (graphic != null)
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: Center(child: graphic),
            )
          else
            Icon(icon, size: iconSize, color: colorText),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kChipFillAlt,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: colorText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h / 2 - h * 0.06);
    final double outerR = (w * 0.46);
    final double innerR = outerR * 0.48;

    Path buildStar(double rOuter, double rInner) {
      final Path p = Path();
      for (int i = 0; i < 10; i++) {
        final double angle = (-90 + i * 36) * math.pi / 180.0;
        final double r = (i % 2 == 0) ? rOuter : rInner;
        final Offset pt = Offset(
          c.dx + r * math.cos(angle),
          c.dy + r * math.sin(angle),
        );
        if (i == 0) {
          p.moveTo(pt.dx, pt.dy);
        } else {
          p.lineTo(pt.dx, pt.dy);
        }
      }
      p.close();
      return p;
    }

    final Path star = buildStar(outerR, innerR);

    const Color fillLight = Color(0xFFFFF2C9);
    const Color fillMid = Color(0xFFFFE6A9);
    const Color strokeBrown = Color(0xFF6E5338);
    const Color innerLine = Color(0xFFE6D08C);

    final Paint fill = Paint()
      ..shader = RadialGradient(
        colors: const [fillLight, fillMid],
      ).createShader(Rect.fromCircle(center: c, radius: outerR));
    canvas.drawPath(star, fill);

    canvas.drawPath(
      star,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round,
    );

    final Path innerStar = buildStar(outerR * 0.62, innerR * 0.62);
    canvas.drawPath(
      innerStar,
      Paint()
        ..color = innerLine
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );

    const Color legDark = Color(0xFF8B6B47);
    const Color legLight = Color(0xFFB08964);
    final double legW = w * 0.14;
    final double legH = h * 0.22;
    final double legY = c.dy + outerR * 0.65;

    RRect legRect(Offset o) => RRect.fromRectAndRadius(
      Rect.fromCenter(center: o, width: legW, height: legH),
      Radius.circular(legW * 0.3),
    );

    final Paint legPaintL = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [legLight, legDark],
      ).createShader(Rect.fromLTWH(0, legY - legH / 2, w / 2, legH));

    final Paint legPaintR = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [legLight, legDark],
      ).createShader(Rect.fromLTWH(w / 2, legY - legH / 2, w / 2, legH));

    canvas.drawRRect(legRect(Offset(c.dx - legW * 0.75, legY)), legPaintL);
    canvas.drawRRect(legRect(Offset(c.dx + legW * 0.75, legY)), legPaintR);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FlowerItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);

    // Colors (match reference style)
    const Color strokeBrown = Color(0xFF6E5338);
    const Color potFill = Color(0xFFD6C9B5);
    const Color potBand = Color(0xFFC8B8A0);
    const Color stemGreen = Color(0xFF4E8A3B);
    const Color leafLight = Color(0xFF78A75A);
    const Color petalLight = Color(0xFFF7C1CF);
    const Color petalMid = Color(0xFFF2A5B5);
    const Color flowerCore = Color(0xFFF3DB6A);

    // Pot
    final double potW = w * 0.58;
    final double potH = h * 0.34;
    final Rect potRect = Rect.fromCenter(
      center: Offset(center.dx, h * 0.76),
      width: potW,
      height: potH,
    );
    final RRect pot = RRect.fromRectAndCorners(
      potRect,
      bottomLeft: Radius.circular(potW * 0.14),
      bottomRight: Radius.circular(potW * 0.14),
      topLeft: Radius.circular(potW * 0.08),
      topRight: Radius.circular(potW * 0.08),
    );
    canvas.drawRRect(pot, Paint()..color = potFill);
    canvas.drawRRect(
      pot,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Pot rim (slight lip)
    final Rect rimRect = Rect.fromCenter(
      center: Offset(potRect.center.dx, potRect.top - potRect.height * 0.12),
      width: potW * 1.05,
      height: potH * 0.28,
    );
    final RRect rim = RRect.fromRectAndRadius(
      rimRect,
      Radius.circular(potW * 0.12),
    );
    canvas.drawRRect(rim, Paint()..color = potFill);
    canvas.drawRRect(
      rim,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Pot decorative band
    final double bandY = potRect.center.dy;
    final RRect band = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(potRect.center.dx, bandY),
        width: potW * 0.86,
        height: potH * 0.22,
      ),
      Radius.circular(potW * 0.16),
    );
    canvas.drawRRect(band, Paint()..color = potBand);

    // Stem
    final Path stem = Path()
      ..moveTo(center.dx, rimRect.top + 6)
      ..cubicTo(center.dx, h * 0.46, center.dx, h * 0.46, center.dx, h * 0.44);
    canvas.drawPath(
      stem,
      Paint()
        ..color = stemGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Leaves (two symmetrical)
    Path leafPath(Offset c, bool left) {
      final double dir = left ? -1 : 1;
      final Path p = Path()
        ..moveTo(c.dx, c.dy)
        ..cubicTo(
          c.dx + dir * 26,
          c.dy - 12,
          c.dx + dir * 36,
          c.dy + 18,
          c.dx + dir * 12,
          c.dy + 26,
        )
        ..cubicTo(
          c.dx + dir * 2,
          c.dy + 30,
          c.dx - dir * 6,
          c.dy + 16,
          c.dx,
          c.dy,
        )
        ..close();
      return p;
    }

    final Offset leafCenter = Offset(center.dx, h * 0.52);
    canvas.drawPath(
      leafPath(Offset(leafCenter.dx - 10, leafCenter.dy), true),
      Paint()..color = leafLight,
    );
    canvas.drawPath(
      leafPath(Offset(leafCenter.dx + 10, leafCenter.dy), false),
      Paint()..color = leafLight,
    );
    // Outline leaves
    canvas.drawPath(
      leafPath(Offset(leafCenter.dx - 10, leafCenter.dy), true),
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawPath(
      leafPath(Offset(leafCenter.dx + 10, leafCenter.dy), false),
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Flower petals (5-point rounded flower)
    final double petalR = w * 0.13;
    for (int i = 0; i < 5; i++) {
      final double a = (-90 + i * 72) * math.pi / 180.0;
      final Offset p = Offset(
        center.dx + math.cos(a) * w * 0.18,
        h * 0.34 + math.sin(a) * w * 0.18,
      );
      final Rect petalRect = Rect.fromCircle(center: p, radius: petalR);
      final Paint petalPaint = Paint()
        ..shader = RadialGradient(
          colors: const [petalLight, petalMid],
        ).createShader(petalRect);
      canvas.drawOval(petalRect, petalPaint);
      canvas.drawOval(
        petalRect,
        Paint()
          ..color = strokeBrown
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
    }

    // Flower center
    final Rect core = Rect.fromCircle(
      center: Offset(center.dx, h * 0.34),
      radius: w * 0.09,
    );
    canvas.drawCircle(core.center, core.width / 2, Paint()..color = flowerCore);
    canvas.drawCircle(
      core.center,
      core.width / 2,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ButterflyItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h * 0.50);

    // Colors
    const Color strokeBrown = Color(0xFF6E5338);
    const Color wingLight = Color(0xFFD1EAFE);
    const Color wingMid = Color(0xFFAED6FB);
    const Color wingDark = Color(0xFF7FBFF1);
    const Color bodyDark = Color(0xFF6B4E3A);
    const Color spot = Color(0xFFF6F6F6);

    Paint wingFill(Rect r) => Paint()
      ..shader = RadialGradient(
        colors: const [wingLight, wingMid, wingDark],
        stops: const [0.0, 0.6, 1.0],
        center: Alignment.topLeft,
        radius: 1.0,
      ).createShader(r);

    final double wingOX = w * 0.22;
    final double wingOY = h * 0.10;
    final Size upperWing = Size(w * 0.28, h * 0.22);
    final Size lowerWing = Size(w * 0.22, h * 0.18);

    RRect wingOval(Offset o, Size s) => RRect.fromRectAndRadius(
      Rect.fromCenter(center: o, width: s.width, height: s.height),
      Radius.circular(s.shortestSide * 0.6),
    );

    // Left upper wing
    final RRect lu = wingOval(Offset(c.dx - wingOX, c.dy - wingOY), upperWing);
    canvas.drawRRect(lu, wingFill(lu.outerRect));
    canvas.drawRRect(
      lu,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Left lower wing
    final RRect ll = wingOval(
      Offset(c.dx - wingOX + w * 0.04, c.dy + wingOY),
      lowerWing,
    );
    canvas.drawRRect(ll, wingFill(ll.outerRect));
    canvas.drawRRect(
      ll,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Right upper wing
    final RRect ru = wingOval(Offset(c.dx + wingOX, c.dy - wingOY), upperWing);
    canvas.drawRRect(ru, wingFill(ru.outerRect));
    canvas.drawRRect(
      ru,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Right lower wing
    final RRect rl = wingOval(
      Offset(c.dx + wingOX - w * 0.04, c.dy + wingOY),
      lowerWing,
    );
    canvas.drawRRect(rl, wingFill(rl.outerRect));
    canvas.drawRRect(
      rl,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Body (thorax + abdomen)
    final Rect bodyRect = Rect.fromCenter(
      center: c,
      width: w * 0.08,
      height: h * 0.44,
    );
    final RRect body = RRect.fromRectAndRadius(
      bodyRect,
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(body, Paint()..color = bodyDark);
    // Head
    canvas.drawCircle(
      Offset(c.dx, bodyRect.top - h * 0.02),
      w * 0.04,
      Paint()..color = bodyDark,
    );

    // Antennae
    final Paint ant = Paint()
      ..color = strokeBrown
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final Path al = Path()
      ..moveTo(c.dx, bodyRect.top - h * 0.02)
      ..cubicTo(
        c.dx - w * 0.06,
        bodyRect.top - h * 0.10,
        c.dx - w * 0.10,
        bodyRect.top - h * 0.14,
        c.dx - w * 0.11,
        bodyRect.top - h * 0.12,
      );
    final Path ar = Path()
      ..moveTo(c.dx, bodyRect.top - h * 0.02)
      ..cubicTo(
        c.dx + w * 0.06,
        bodyRect.top - h * 0.10,
        c.dx + w * 0.10,
        bodyRect.top - h * 0.14,
        c.dx + w * 0.11,
        bodyRect.top - h * 0.12,
      );
    canvas.drawPath(al, ant);
    canvas.drawPath(ar, ant);

    // Wing spots (simple circles/ovals)
    void spotCircle(Offset o, double r) {
      canvas.drawCircle(o, r, Paint()..color = spot.withOpacity(0.95));
    }

    // Left spots
    spotCircle(
      Offset(lu.center.dx - w * 0.06, lu.center.dy - h * 0.02),
      w * 0.018,
    );
    spotCircle(
      Offset(lu.center.dx - w * 0.01, lu.center.dy - h * 0.05),
      w * 0.014,
    );
    spotCircle(
      Offset(ll.center.dx - w * 0.03, ll.center.dy + h * 0.01),
      w * 0.016,
    );
    spotCircle(
      Offset(ll.center.dx + w * 0.02, ll.center.dy + h * 0.03),
      w * 0.012,
    );

    // Right spots (mirrored)
    spotCircle(
      Offset(ru.center.dx + w * 0.06, ru.center.dy - h * 0.02),
      w * 0.018,
    );
    spotCircle(
      Offset(ru.center.dx + w * 0.01, ru.center.dy - h * 0.05),
      w * 0.014,
    );
    spotCircle(
      Offset(rl.center.dx + w * 0.03, rl.center.dy + h * 0.01),
      w * 0.016,
    );
    spotCircle(
      Offset(rl.center.dx - w * 0.02, rl.center.dy + h * 0.03),
      w * 0.012,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BowItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h * 0.52);

    // Colors
    const Color strokeBrown = Color(0xFF6E5338);
    const Color bowLight = Color(0xFFF1A29A);
    const Color bowMid = Color(0xFFE07D73);
    const Color bowDark = Color(0xFFCC6B60);

    Paint fillFor(Path path, {Alignment center = Alignment.center}) {
      final Rect r = path.getBounds();
      return Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [bowLight, bowMid, bowDark],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(r);
    }

    // Knot
    final RRect knot = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: c.translate(0, -h * 0.02),
        width: w * 0.20,
        height: h * 0.16,
      ),
      Radius.circular(w * 0.06),
    );

    // Left loop
    final Path left = Path()
      ..moveTo(c.dx - w * 0.10, c.dy - h * 0.08)
      ..cubicTo(
        c.dx - w * 0.36,
        c.dy - h * 0.22,
        c.dx - w * 0.36,
        c.dy + h * 0.16,
        c.dx - w * 0.10,
        c.dy + h * 0.06,
      )
      ..quadraticBezierTo(
        c.dx - w * 0.16,
        c.dy - h * 0.00,
        c.dx - w * 0.10,
        c.dy - h * 0.08,
      )
      ..close();

    // Right loop
    final Path right = Path()
      ..moveTo(c.dx + w * 0.10, c.dy - h * 0.08)
      ..cubicTo(
        c.dx + w * 0.36,
        c.dy - h * 0.22,
        c.dx + w * 0.36,
        c.dy + h * 0.16,
        c.dx + w * 0.10,
        c.dy + h * 0.06,
      )
      ..quadraticBezierTo(
        c.dx + w * 0.16,
        c.dy - h * 0.00,
        c.dx + w * 0.10,
        c.dy - h * 0.08,
      )
      ..close();

    // Tails
    Path tail(Offset start, bool leftSide) {
      final double dir = leftSide ? -1 : 1;
      return Path()
        ..moveTo(start.dx, start.dy)
        ..lineTo(start.dx + dir * w * 0.08, start.dy + h * 0.22)
        ..lineTo(start.dx + dir * w * 0.16, start.dy + h * 0.10)
        ..quadraticBezierTo(
          start.dx + dir * w * 0.10,
          start.dy + h * 0.02,
          start.dx,
          start.dy,
        )
        ..close();
    }

    final Path leftTail = tail(c.translate(-w * 0.06, h * 0.06), true);
    final Path rightTail = tail(c.translate(w * 0.06, h * 0.06), false);

    // Paint shapes
    for (final Path p in [left, right, leftTail, rightTail]) {
      canvas.drawPath(p, fillFor(p));
      canvas.drawPath(
        p,
        Paint()
          ..color = strokeBrown
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2
          ..strokeJoin = StrokeJoin.round,
      );
    }
    canvas.drawRRect(
      knot,
      Paint()
        ..shader = LinearGradient(
          colors: const [bowLight, bowDark],
        ).createShader(knot.outerRect),
    );
    canvas.drawRRect(
      knot,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Highlights on loops
    Paint hi = Paint()..color = Colors.white.withOpacity(0.28);
    canvas.drawOval(
      Rect.fromCenter(
        center: c.translate(-w * 0.18, -h * 0.06),
        width: w * 0.10,
        height: h * 0.05,
      ),
      hi,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: c.translate(w * 0.18, -h * 0.06),
        width: w * 0.10,
        height: h * 0.05,
      ),
      hi,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Public wrappers to reuse item drawings in other files (e.g., award dialog)
class StarItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      _StarItemPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FlowerItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      _FlowerItemPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ButterflyItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      _ButterflyItemPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BowItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) => _BowItemPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

@immutable
class _HomeStickerPlacement {
  const _HomeStickerPlacement({
    required this.id,
    required this.itemId,
    required this.fx,
    required this.fy,
  });
  final String id;
  final int itemId;
  final double fx;
  final double fy;

  _HomeStickerPlacement copyWith({
    String? id,
    int? itemId,
    double? fx,
    double? fy,
  }) {
    return _HomeStickerPlacement(
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

  factory _HomeStickerPlacement.fromJson(Map<String, dynamic> m) {
    return _HomeStickerPlacement(
      id: m['id'] as String,
      itemId: m['itemId'] as int,
      fx: (m['fx'] as num).toDouble(),
      fy: (m['fy'] as num).toDouble(),
    );
  }
}

class HomeStickerPanel extends StatelessWidget {
  const HomeStickerPanel({
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
            _HomePanelItemRow(
              label: '별 x',
              count: counts[1] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(1),
            ),
            _HomePanelItemRow(
              label: '화분 x',
              count: counts[2] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(2),
            ),
            _HomePanelItemRow(
              label: '나비 x',
              count: counts[3] ?? 0,
              stickerSize: stickerSize,
              child: itemBuilder(3),
            ),
            _HomePanelItemRow(
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

class _HomePanelItemRow extends StatelessWidget {
  const _HomePanelItemRow({
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
