import 'dart:math' as math;
import 'package:flutter/material.dart';

class QuestIconPainter extends CustomPainter {
  QuestIconPainter(this.title);
  final String title;

  @override
  void paint(Canvas canvas, Size size) {
    final t = title.toLowerCase();

    if (t.contains('설거지') || t.contains('dish')) {
      _drawDishesIcon(canvas, size);
    } else if (t.contains('영어') ||
        t.contains('english') ||
        t.contains('meetup')) {
      _drawChatIcon(canvas, size);
    } else if (t.contains('주문') || t.contains('order')) {
      _drawDeliveryIcon(canvas, size);
    } else if (t.contains('문') || t.contains('door') || t.contains('repair')) {
      _drawHammerIcon(canvas, size);
    } else if (t.contains('물') || t.contains('plant') || t.contains('water')) {
      _drawWateringIcon(canvas, size);
    } else if (t.contains('book')) {
      _drawBookIcon(canvas, size);
    } else {
      _drawDefaultIcon(canvas, size);
    }
  }

  void _drawDishesIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final plateRadius = size.width * 0.3;

    // Stack of plates
    for (int i = 0; i < 5; i++) {
      final offset = Offset(center.dx, center.dy - i * 4);
      final paint = Paint()
        ..color = const Color(0xFFE8F4FD)
        ..style = PaintingStyle.fill;

      canvas.drawOval(
        Rect.fromCenter(
          center: offset,
          width: plateRadius * 2,
          height: plateRadius * 0.4,
        ),
        paint,
      );

      // Plate rim
      final rimPaint = Paint()
        ..color = const Color(0xFF2B5F87)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawOval(
        Rect.fromCenter(
          center: offset,
          width: plateRadius * 2,
          height: plateRadius * 0.4,
        ),
        rimPaint,
      );
    }

    // Sparkles
    _drawSparkle(canvas, Offset(center.dx - 15, center.dy - 20), 5);
    _drawSparkle(canvas, Offset(center.dx + 18, center.dy - 15), 4);

    // Bubbles
    final bubblePaint = Paint()
      ..color = const Color(0xFF87CEEB).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx - 10, center.dy + 15), 5, bubblePaint);
    canvas.drawCircle(Offset(center.dx + 8, center.dy + 18), 3, bubblePaint);
  }

  void _drawChatIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // First bubble - "Hi"
    final bubble1Rect = Rect.fromCenter(
      center: Offset(center.dx - 10, center.dy - 5),
      width: size.width * 0.35,
      height: size.height * 0.25,
    );
    _drawChatBubble(canvas, bubble1Rect, const Color(0xFFFFE4B5), 'Hi');

    // Second bubble - "안녕"
    final bubble2Rect = Rect.fromCenter(
      center: Offset(center.dx + 10, center.dy + 5),
      width: size.width * 0.35,
      height: size.height * 0.25,
    );
    _drawChatBubble(canvas, bubble2Rect, const Color(0xFFFFB6C1), '안녕');
  }

  void _drawChatBubble(Canvas canvas, Rect rect, Color color, String text) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rRect, paint);

    // Border
    final borderPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rRect, borderPaint);

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black87,
          fontSize: rect.height * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        rect.center.dx - textPainter.width / 2,
        rect.center.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawDeliveryIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Box
    final boxRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.5,
      height: size.height * 0.4,
    );

    final boxPaint = Paint()
      ..color = const Color(0xFFD2691E)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(4)),
      boxPaint,
    );

    // Box tape
    final tapePaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(center: center, width: size.width * 0.5, height: 4),
      tapePaint,
    );

    // Checkmark
    final checkPaint = Paint()
      ..color = const Color(0xFF32CD32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(center.dx - 8, center.dy - 5)
      ..lineTo(center.dx - 2, center.dy + 2)
      ..lineTo(center.dx + 10, center.dy - 10);

    canvas.drawPath(path, checkPaint);
  }

  void _drawHammerIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Wood planks
    final plankPaint = Paint()
      ..color = const Color(0xFFDEB887)
      ..style = PaintingStyle.fill;

    // Draw 3 planks
    for (int i = 0; i < 3; i++) {
      final plankRect = Rect.fromCenter(
        center: Offset(center.dx - 10 + i * 10, center.dy + 10),
        width: size.width * 0.15,
        height: size.height * 0.35,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(plankRect, const Radius.circular(2)),
        plankPaint,
      );

      // Wood grain
      final grainPaint = Paint()
        ..color = const Color(0xFFCD853F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawLine(
        Offset(plankRect.left + 2, plankRect.top + 5),
        Offset(plankRect.left + 2, plankRect.bottom - 5),
        grainPaint,
      );
    }

    // Hammer
    final hammerHandle = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 5, center.dy - 5),
          width: 4,
          height: size.height * 0.3,
        ),
        const Radius.circular(2),
      ),
      hammerHandle,
    );

    // Hammer head
    final hammerHead = Paint()
      ..color = const Color(0xFF708090)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(center.dx + 5, center.dy - 15),
          width: size.width * 0.25,
          height: size.height * 0.15,
        ),
        const Radius.circular(3),
      ),
      hammerHead,
    );

    // Impact lines
    _drawImpactLines(canvas, Offset(center.dx - 5, center.dy - 8));
  }

  void _drawWateringIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Watering can
    final canPaint = Paint()
      ..color = const Color(0xFF87CEEB)
      ..style = PaintingStyle.fill;

    // Can body
    final canRect = Rect.fromCenter(
      center: Offset(center.dx - 5, center.dy),
      width: size.width * 0.3,
      height: size.height * 0.25,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(canRect, const Radius.circular(4)),
      canPaint,
    );

    // Spout
    final spoutPath = Path()
      ..moveTo(canRect.right, canRect.top + 5)
      ..lineTo(canRect.right + 12, canRect.top - 5)
      ..lineTo(canRect.right + 12, canRect.top)
      ..lineTo(canRect.right, canRect.top + 10);

    canvas.drawPath(spoutPath, canPaint);

    // Water drops
    final waterPaint = Paint()
      ..color = const Color(0xFF4169E1).withOpacity(0.7)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(canRect.right + 15, canRect.top + i * 5),
        2,
        waterPaint,
      );
    }

    // Plant
    final plantPot = Paint()
      ..color = const Color(0xFFD2691E)
      ..style = PaintingStyle.fill;

    final potPath = Path()
      ..moveTo(center.dx + 5, center.dy + 12)
      ..lineTo(center.dx + 3, center.dy + 20)
      ..lineTo(center.dx + 17, center.dy + 20)
      ..lineTo(center.dx + 15, center.dy + 12)
      ..close();

    canvas.drawPath(potPath, plantPot);

    // Sprout
    final sproutPaint = Paint()
      ..color = const Color(0xFF32CD32)
      ..style = PaintingStyle.fill;

    // Stem
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx + 10, center.dy + 8),
        width: 2,
        height: 8,
      ),
      sproutPaint,
    );

    // Leaves
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 7, center.dy + 5),
        width: 6,
        height: 8,
      ),
      sproutPaint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 13, center.dy + 5),
        width: 6,
        height: 8,
      ),
      sproutPaint,
    );
  }

  void _drawBookIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Book cover
    final bookPaint = Paint()
      ..color = const Color(0xFFB22222)
      ..style = PaintingStyle.fill;

    final bookRect = Rect.fromCenter(
      center: center,
      width: size.width * 0.5,
      height: size.height * 0.4,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bookRect, const Radius.circular(4)),
      bookPaint,
    );

    // Book spine
    final spinePaint = Paint()
      ..color = const Color(0xFF8B0000)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(bookRect.left, bookRect.top, 4, bookRect.height),
      spinePaint,
    );

    // Pages
    final pagesPaint = Paint()
      ..color = const Color(0xFFFFFACD)
      ..style = PaintingStyle.fill;

    final pagesRect = Rect.fromCenter(
      center: Offset(center.dx + 2, center.dy),
      width: size.width * 0.35,
      height: size.height * 0.3,
    );

    canvas.drawRect(pagesRect, pagesPaint);

    // Heart
    _drawHeart(canvas, center, size.width * 0.15);
  }

  void _drawDefaultIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Checkmark circle
    final circlePaint = Paint()
      ..color = const Color(0xFF32CD32)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, size.width * 0.35, circlePaint);

    // Check
    final checkPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(center.dx - 10, center.dy)
      ..lineTo(center.dx - 3, center.dy + 8)
      ..lineTo(center.dx + 10, center.dy - 8);

    canvas.drawPath(path, checkPaint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Draw star shape
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..lineTo(center.dx + size * 0.3, center.dy - size * 0.3)
      ..lineTo(center.dx + size, center.dy)
      ..lineTo(center.dx + size * 0.3, center.dy + size * 0.3)
      ..lineTo(center.dx, center.dy + size)
      ..lineTo(center.dx - size * 0.3, center.dy + size * 0.3)
      ..lineTo(center.dx - size, center.dy)
      ..lineTo(center.dx - size * 0.3, center.dy - size * 0.3)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawImpactLines(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final angle = (i - 1) * 0.3;
      final dx = 8 * math.cos(angle);
      final dy = 8 * math.sin(angle);

      canvas.drawLine(center, Offset(center.dx + dx, center.dy + dy), paint);
    }
  }

  void _drawHeart(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = const Color(0xFFFF69B4)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy + size * 0.5)
      ..cubicTo(
        center.dx - size * 0.5,
        center.dy,
        center.dx - size * 0.5,
        center.dy - size * 0.3,
        center.dx - size * 0.2,
        center.dy - size * 0.3,
      )
      ..cubicTo(
        center.dx,
        center.dy - size * 0.3,
        center.dx,
        center.dy - size * 0.1,
        center.dx,
        center.dy,
      )
      ..cubicTo(
        center.dx,
        center.dy - size * 0.1,
        center.dx,
        center.dy - size * 0.3,
        center.dx + size * 0.2,
        center.dy - size * 0.3,
      )
      ..cubicTo(
        center.dx + size * 0.5,
        center.dy - size * 0.3,
        center.dx + size * 0.5,
        center.dy,
        center.dx,
        center.dy + size * 0.5,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant QuestIconPainter oldDelegate) {
    return oldDelegate.title != title;
  }
}

class RewardIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Gift box
    final boxRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 5),
      width: size.width * 0.6,
      height: size.height * 0.5,
    );

    // Yellow and white stripes
    final stripeWidth = boxRect.width / 6;
    for (int i = 0; i < 6; i++) {
      final stripePaint = Paint()
        ..color = i % 2 == 0 ? const Color(0xFFFFD700) : Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(
          boxRect.left + i * stripeWidth,
          boxRect.top,
          stripeWidth,
          boxRect.height,
        ),
        stripePaint,
      );
    }

    // Box border
    final borderPaint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, const Radius.circular(4)),
      borderPaint,
    );

    // Lid
    final lidRect = Rect.fromCenter(
      center: Offset(center.dx, boxRect.top - 5),
      width: size.width * 0.65,
      height: size.height * 0.15,
    );

    final lidPaint = Paint()
      ..color = const Color(0xFFD4A574)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(lidRect, const Radius.circular(4)),
      lidPaint,
    );

    // Keyhole
    final keyholePaint = Paint()
      ..color = const Color(0xFF8B7355)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.dx, lidRect.center.dy), 4, keyholePaint);

    // Ribbon
    final ribbonPaint = Paint()
      ..color = const Color(0xFFDC143C)
      ..style = PaintingStyle.fill;

    // Vertical ribbon
    canvas.drawRect(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.15,
        height: size.height * 0.8,
      ),
      ribbonPaint,
    );

    // Bow
    _drawBow(
      canvas,
      Offset(center.dx, center.dy - size.height * 0.35),
      size.width * 0.3,
    );

    // Glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);

    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect.inflate(5), const Radius.circular(4)),
      glowPaint,
    );
  }

  void _drawBow(Canvas canvas, Offset center, double size) {
    final bowPaint = Paint()
      ..color = const Color(0xFFDC143C)
      ..style = PaintingStyle.fill;

    // Left loop
    final leftPath = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(
        center.dx - size * 0.6,
        center.dy - size * 0.3,
        center.dx - size * 0.6,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx - size * 0.6,
        center.dy + size * 0.3,
        center.dx,
        center.dy,
      );

    canvas.drawPath(leftPath, bowPaint);

    // Right loop
    final rightPath = Path()
      ..moveTo(center.dx, center.dy)
      ..quadraticBezierTo(
        center.dx + size * 0.6,
        center.dy - size * 0.3,
        center.dx + size * 0.6,
        center.dy,
      )
      ..quadraticBezierTo(
        center.dx + size * 0.6,
        center.dy + size * 0.3,
        center.dx,
        center.dy,
      );

    canvas.drawPath(rightPath, bowPaint);

    // Center knot
    canvas.drawCircle(center, size * 0.15, bowPaint);
  }

  @override
  bool shouldRepaint(covariant RewardIconPainter oldDelegate) => false;
}
