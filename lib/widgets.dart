import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'constants.dart';
import 'models.dart';
import 'quest_icon_painter.dart';

// Custom quest icons with colorful style
class QuestGlyph extends StatelessWidget {
  const QuestGlyph({
    super.key,
    required this.title,
    this.iconUrl,
    this.size = 64,
  });
  final String title;
  final String? iconUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = iconUrl != null && iconUrl!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: Colors.white,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: size,
              height: size,
              child: hasIcon
                  ? _buildIconImage(iconUrl!)
                  : CustomPaint(painter: QuestIconPainter(title)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconImage(String url) {
    if (url.startsWith('data:image')) {
      final String base64Data = url.split(',').last;
      try {
        return Image.memory(base64Decode(base64Data), fit: BoxFit.cover);
      } catch (_) {
        return const Icon(Icons.image_not_supported, color: colorAccent);
      }
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return const Icon(Icons.image_not_supported, color: colorAccent);
      },
    );
  }
}

class RewardGlyph extends StatelessWidget {
  const RewardGlyph({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      child: CustomPaint(painter: RewardIconPainter()),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: colorAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: colorPaper,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('🐹', style: TextStyle(fontSize: 36)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading your quests...',
              style: TextStyle(
                color: colorPaper,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: colorPaper, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PatternPainter());
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint outline = Paint()
      ..color = Colors.black.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    void drawBook(Offset center, double s, double angleRadians) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angleRadians);

      final RRect cover = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, 0), width: s * 1.2, height: s * 0.8),
        Radius.circular(s * 0.12),
      );
      canvas.drawRRect(cover, outline);

      // Label on the cover
      final RRect label = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(0, -s * 0.06),
          width: s * 0.55,
          height: s * 0.25,
        ),
        Radius.circular(s * 0.06),
      );
      canvas.drawRRect(label, outline);

      // Page lines
      final double pw = s * 1.0;
      final double py = s * 0.42;
      final Path pages = Path()
        ..moveTo(-pw / 2, py)
        ..lineTo(pw / 2, py)
        ..moveTo(-pw / 2 + s * 0.1, py - s * 0.1)
        ..lineTo(pw / 2 - s * 0.08, py - s * 0.1)
        ..moveTo(-pw / 2 + s * 0.18, py - s * 0.2)
        ..lineTo(pw / 2 - s * 0.16, py - s * 0.2);
      canvas.drawPath(pages, outline);

      canvas.restore();
    }

    const double step = 180;
    bool alt = false;
    for (double y = 40; y < size.height; y += step) {
      for (double x = 40; x < size.width; x += step) {
        drawBook(Offset(x, y), 56, alt ? -0.18 : 0.18);
        alt = !alt;
      }
      alt = !alt;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CharacterView extends StatelessWidget {
  const CharacterView({super.key, required this.imageUrl, required this.state});
  final String imageUrl;
  final CharacterState state;

  @override
  Widget build(BuildContext context) {
    final Widget image = Image.network(imageUrl, fit: BoxFit.contain);
    if (state == CharacterState.happy) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          final double translate =
              -4 * (value < 0.5 ? value * 2 : (1 - value) * 2);
          return Transform.translate(
            offset: Offset(0, translate),
            child: child,
          );
        },
        child: image,
      );
    }
    if (state == CharacterState.thinking) {
      return Opacity(opacity: 0.8, child: image);
    }
    return image;
  }
}

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, this.title = '일일 임무', this.showTimer = true});
  final String title;
  final bool showTimer;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -28,
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            widthFactor: 1,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                height: kHeaderPillHeight + 6,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: colorAccent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
          if (showTimer) ...<Widget>[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.access_time, size: 20, color: colorText),
                SizedBox(width: 6),
                Text(
                  '6 시간 24 분',
                  style: TextStyle(
                    fontSize: 18,
                    color: colorText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class CornerDecoration extends StatelessWidget {
  const CornerDecoration({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        '?',
        style: TextStyle(
          color: colorPaper,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }
}

class TopRightCharacterBadge extends StatelessWidget {
  const TopRightCharacterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFF0D8A5),
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
      child: Stack(
        alignment: Alignment.center,
        children: const <Widget>[
          Text('🐻', style: TextStyle(fontSize: 44)),
          Positioned(
            top: 8,
            child: Icon(Icons.emoji_events, color: Color(0xFFCCAA66), size: 20),
          ),
        ],
      ),
    );
  }
}

class QuestListView extends StatelessWidget {
  const QuestListView({
    super.key,
    required this.quests,
    required this.onComplete,
  });
  final List<Quest> quests;
  final void Function(int id) onComplete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: quests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          QuestItem(quest: quests[index], onComplete: onComplete),
    );
  }
}

class QuestGridView extends StatelessWidget {
  const QuestGridView({
    super.key,
    required this.quests,
    required this.onComplete,
    this.onDelete,
    this.emptyMessage,
  });
  final List<Quest> quests;
  final void Function(int id) onComplete;
  final void Function(int id)? onDelete;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 96,
                    height: 96,
                    decoration: const BoxDecoration(
                      color: colorAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: colorPaper,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('🐹', style: TextStyle(fontSize: 36)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage ?? '일일 임무를 등록하세요',
              style: const TextStyle(
                color: colorText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.4,
      ),
      itemCount: quests.length,
      itemBuilder: (context, index) => QuestCard(
        quest: quests[index],
        onComplete: onComplete,
        onDelete: onDelete,
      ),
    );
  }
}

class QuestItem extends StatelessWidget {
  const QuestItem({super.key, required this.quest, required this.onComplete});
  final Quest quest;
  final void Function(int id) onComplete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                QuestGlyph(
                  title: quest.title,
                  iconUrl: quest.iconUrl,
                  size: 56,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    quest.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              if (!quest.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6DCB5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${quest.progress}/${quest.target}',
                    style: const TextStyle(
                      color: colorText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              _CompletionIcon(completed: quest.isCompleted),
              const SizedBox(width: 12),
              InkWell(
                onTap: quest.isCompleted ? null : () => onComplete(quest.id),
                child: _RewardTile(
                  imageUrl: quest.rewardUrl,
                  isCompleted: quest.isCompleted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashedRRectPainter extends CustomPainter {
  const DashedRRectPainter({
    required this.strokeColor,
    required this.fillColor,
    required this.radius,
  });
  final Color strokeColor;
  final Color fillColor;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect outer = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final Paint fill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(outer, fill);

    final Paint stroke = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = kQuestCardStroke;

    const double dash = kQuestCardDash;
    const double gap = kQuestCardGap;
    final Path path = Path()..addRRect(outer.deflate(10));
    for (final ui.PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double len = (distance + dash) <= metric.length
            ? dash
            : (metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + len), stroke);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRRectPainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.radius != radius;
  }
}

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.onComplete,
    this.onDelete,
  });
  final Quest quest;
  final void Function(int id) onComplete;
  final void Function(int id)? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onDelete != null ? () => onDelete!(quest.id) : null,
      child: CustomPaint(
        painter: const DashedRRectPainter(
          strokeColor: kCardStroke,
          fillColor: kCardFill,
          radius: kQuestCardRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  QuestGlyph(
                    title: quest.title,
                    iconUrl: quest.iconUrl,
                    size: 52,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quest.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: colorText,
                      ),
                    ),
                  ),
                  // Removed duplicate top progress chip
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: kChipFillAlt,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${quest.progress}/${quest.target}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: colorText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _CompletionIcon(completed: quest.isCompleted),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: quest.isCompleted
                        ? null
                        : () => onComplete(quest.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: _RewardTile(
                        imageUrl: quest.rewardUrl,
                        isCompleted: quest.isCompleted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionIcon extends StatelessWidget {
  const _CompletionIcon({required this.completed});
  final bool completed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: kBadgeSize,
      height: kBadgeSize,
      decoration: const BoxDecoration(
        color: kChipFillAlt,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: completed
            ? const SizedBox(
                width: 30,
                height: 30,
                child: CustomPaint(
                  painter: _CheckPainter(color: Colors.green, strokeWidth: 3),
                ),
              )
            : const Text(
                '?',
                style: TextStyle(
                  color: colorText,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.color, this.strokeWidth = 3});
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 24.0;
    final double tx = (size.width - 24.0 * scale) / 2.0;
    final double ty = (size.height - 24.0 * scale) / 2.0;
    canvas.save();
    canvas.translate(tx, ty);
    canvas.scale(scale, scale);

    final Path path = Path()
      ..moveTo(5, 13)
      ..lineTo(9, 17)
      ..lineTo(19, 7);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.imageUrl, required this.isCompleted});
  final String? imageUrl;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final Widget content = Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? _buildRewardImage(imageUrl!)
            : CustomPaint(
                size: const Size(40, 40),
                painter: RewardIconPainter(),
              ),
      ),
    );

    if (!isCompleted) return content;

    return Opacity(
      opacity: 0.7,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.6065,
          0.3575,
          0.0360,
          0,
          0,
          0.1065,
          0.8575,
          0.0360,
          0,
          0,
          0.1065,
          0.3575,
          0.5360,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: content,
      ),
    );
  }

  Widget _buildRewardImage(String url) {
    if (url.startsWith('data:image')) {
      final String base64Data = url.split(',').last;
      try {
        return Image.memory(base64Decode(base64Data), fit: BoxFit.contain);
      } catch (_) {
        return const Icon(Icons.image_not_supported, color: colorAccent);
      }
    }
    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.image_not_supported, color: colorAccent),
    );
  }
}

class RewardDialog extends StatelessWidget {
  const RewardDialog({super.key, required this.reward, required this.onClaim});
  final RewardInfo reward;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorPaper,
            borderRadius: BorderRadius.circular(24),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Quest Complete!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: colorText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You finished ${reward.questName} and got a reward!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: colorText),
              ),
              const SizedBox(height: 16),
              if (reward.imageUrl.isNotEmpty)
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Image.network(reward.imageUrl, fit: BoxFit.contain),
                )
              else
                const Icon(Icons.card_giftcard, size: 120, color: colorAccent),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  elevation: 6,
                ),
                onPressed: onClaim,
                child: const Text(
                  'Claim',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterQuestScreen extends StatelessWidget {
  const RegisterQuestScreen({super.key});

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
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.fromLTRB(24, 74, 24, 24),
                          child: _RegisterForm(),
                        ),
                        const HeaderBar(title: '일일 임무 등록', showTimer: false),
                      ],
                    ),
                  ),
                ),
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

class _RegisterForm extends StatefulWidget {
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: const <Widget>[
              Icon(Icons.edit, color: colorText),
              SizedBox(width: 8),
              Text(
                '새 임무 정보를 입력하세요',
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
                hintText: '예: 설거지',
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
                hintText: '예: 35',
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
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
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
          ),
        ],
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
