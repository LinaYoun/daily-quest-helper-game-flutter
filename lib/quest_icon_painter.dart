import 'package:flutter/material.dart';

class QuestIconPainter extends CustomPainter {
  QuestIconPainter(this.title);
  final String title;

  @override
  void paint(Canvas canvas, Size size) {
    // Always draw scroll icon for all quests
    _drawScrollIcon(canvas, size);
  }

  void _drawScrollIcon(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Colors for scroll
    const Color scrollBase = Color(0xFFE8D5A6);
    const Color scrollDark = Color(0xFFD4A76A);
    const Color scrollDarker = Color(0xFFB8935F);
    const Color textLines = Color(0xFF8B6F47);

    // Main scroll body
    final double scrollWidth = size.width * 0.7;
    final double scrollHeight = size.height * 0.8;
    final double cornerRadius = size.width * 0.15;

    // Draw main scroll rectangle with rounded corners
    final scrollRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: scrollWidth, height: scrollHeight),
      Radius.circular(cornerRadius),
    );

    canvas.drawRRect(scrollRect, Paint()..color = scrollBase);

    // Draw top rolled part
    final double rollRadius = size.width * 0.12;
    final double rollY = center.dy - scrollHeight / 2 + rollRadius / 2;

    // Left roll
    canvas.drawCircle(
      Offset(center.dx - scrollWidth / 2 + rollRadius, rollY),
      rollRadius,
      Paint()..color = scrollDark,
    );

    // Right roll
    canvas.drawCircle(
      Offset(center.dx + scrollWidth / 2 - rollRadius, rollY),
      rollRadius,
      Paint()..color = scrollDark,
    );

    // Bottom rolled part
    final double bottomRollY = center.dy + scrollHeight / 2 - rollRadius / 2;

    // Left bottom roll
    canvas.drawCircle(
      Offset(center.dx - scrollWidth / 2 + rollRadius, bottomRollY),
      rollRadius,
      Paint()..color = scrollDark,
    );

    // Right bottom roll
    canvas.drawCircle(
      Offset(center.dx + scrollWidth / 2 - rollRadius, bottomRollY),
      rollRadius,
      Paint()..color = scrollDark,
    );

    // Inner shadows for depth
    final innerPaint = Paint()
      ..color = scrollDarker.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Left inner shadow
    canvas.drawLine(
      Offset(center.dx - scrollWidth / 2 + rollRadius * 1.5, rollY),
      Offset(center.dx - scrollWidth / 2 + rollRadius * 1.5, bottomRollY),
      innerPaint,
    );

    // Right inner shadow
    canvas.drawLine(
      Offset(center.dx + scrollWidth / 2 - rollRadius * 1.5, rollY),
      Offset(center.dx + scrollWidth / 2 - rollRadius * 1.5, bottomRollY),
      innerPaint,
    );

    // Draw text lines
    final linePaint = Paint()
      ..color = textLines
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final double lineSpacing = scrollHeight / 8;
    final double lineWidth = scrollWidth * 0.5;
    final double startY = center.dy - scrollHeight / 2 + lineSpacing * 2;

    for (int i = 0; i < 4; i++) {
      final double y = startY + i * lineSpacing;
      final double currentLineWidth = lineWidth * (0.7 + (i % 2) * 0.3);

      canvas.drawLine(
        Offset(center.dx - currentLineWidth / 2, y),
        Offset(center.dx + currentLineWidth / 2, y),
        linePaint,
      );
    }

    // Add highlight on rolls
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Top left highlight
    canvas.drawCircle(
      Offset(center.dx - scrollWidth / 2 + rollRadius - 3, rollY - 3),
      rollRadius * 0.3,
      highlightPaint,
    );

    // Top right highlight
    canvas.drawCircle(
      Offset(center.dx + scrollWidth / 2 - rollRadius - 3, rollY - 3),
      rollRadius * 0.3,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant QuestIconPainter oldDelegate) {
    return oldDelegate.title != title;
  }
}

class RewardIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Colors matching the reference image
    const Color white = Colors.white;
    const Color boxGold = Color(0xFFE6C16B);
    const Color boxGoldLight = Color(0xFFFFD700);
    const Color boxGoldDark = Color(0xFFD4AF37);
    const Color ribbonRed = Color(0xFFDC143C);

    // 1) White rounded background
    final RRect background = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width * 0.22),
    );
    canvas.drawRRect(background, Paint()..color = white);

    // 2) Main gift box body (front view, not isometric)
    final double boxW = size.width * 0.62;
    final double boxH = size.height * 0.52;
    final Offset boxCenter = Offset(center.dx, center.dy + size.height * 0.08);

    final Rect boxRect = Rect.fromCenter(
      center: boxCenter,
      width: boxW,
      height: boxH,
    );

    // Draw main box with gradient
    final Paint boxPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [boxGoldLight, boxGold, boxGoldDark],
        stops: [0.0, 0.5, 1.0],
      ).createShader(boxRect);
    canvas.drawRect(boxRect, boxPaint);

    // Box outline
    canvas.drawRect(
      boxRect,
      Paint()
        ..color = boxGoldDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Lid (box top)
    final double lidH = boxH * 0.25;
    final Rect lidRect = Rect.fromLTWH(
      boxRect.left - size.width * 0.02,
      boxRect.top - lidH * 0.3,
      boxW + size.width * 0.04,
      lidH,
    );

    final Paint lidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [boxGoldLight, boxGold],
      ).createShader(lidRect);
    canvas.drawRect(lidRect, lidPaint);

    // Lid outline
    canvas.drawRect(
      lidRect,
      Paint()
        ..color = boxGoldDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Vertical ribbon
    final double ribbonW = boxW * 0.22;
    final Rect verticalRibbon = Rect.fromCenter(
      center: Offset(boxCenter.dx, boxCenter.dy),
      width: ribbonW,
      height: boxH + lidH * 0.5,
    );
    canvas.drawRect(verticalRibbon, Paint()..color = ribbonRed);

    // Horizontal ribbon
    final Rect horizontalRibbon = Rect.fromCenter(
      center: Offset(boxCenter.dx, lidRect.center.dy),
      width: boxW + size.width * 0.04,
      height: ribbonW * 0.8,
    );
    canvas.drawRect(horizontalRibbon, Paint()..color = ribbonRed);

    // Bow on top
    final Offset bowCenter = Offset(
      boxCenter.dx,
      lidRect.top - size.height * 0.05,
    );
    _drawBow(canvas, bowCenter, size.width * 0.35);
  }

  void _drawBow(Canvas canvas, Offset center, double size) {
    const Color ribbonRed = Color(0xFFDC143C);
    const Color ribbonRedDark = Color(0xFF8B0000);
    const Color ribbonRedLight = Color(0xFFFF6B6B);

    // Left bow loop
    final leftPath = Path()
      ..moveTo(center.dx, center.dy)
      ..cubicTo(
        center.dx - size * 0.15,
        center.dy - size * 0.35,
        center.dx - size * 0.45,
        center.dy - size * 0.25,
        center.dx - size * 0.5,
        center.dy - size * 0.05,
      )
      ..cubicTo(
        center.dx - size * 0.52,
        center.dy + size * 0.05,
        center.dx - size * 0.45,
        center.dy + size * 0.25,
        center.dx - size * 0.15,
        center.dy + size * 0.35,
      )
      ..close();

    canvas.drawPath(leftPath, Paint()..color = ribbonRed);

    // Right bow loop - mirrored
    final rightPath = Path()
      ..moveTo(center.dx, center.dy)
      ..cubicTo(
        center.dx + size * 0.15,
        center.dy - size * 0.35,
        center.dx + size * 0.45,
        center.dy - size * 0.25,
        center.dx + size * 0.5,
        center.dy - size * 0.05,
      )
      ..cubicTo(
        center.dx + size * 0.52,
        center.dy + size * 0.05,
        center.dx + size * 0.45,
        center.dy + size * 0.25,
        center.dx + size * 0.15,
        center.dy + size * 0.35,
      )
      ..close();

    canvas.drawPath(rightPath, Paint()..color = ribbonRed);

    // Center knot
    final double knotSize = size * 0.12;
    canvas.drawCircle(center, knotSize, Paint()..color = ribbonRedDark);

    // Highlight on knot
    canvas.drawCircle(
      Offset(center.dx - knotSize * 0.3, center.dy - knotSize * 0.3),
      knotSize * 0.4,
      Paint()..color = ribbonRedLight.withOpacity(0.6),
    );
  }

  @override
  bool shouldRepaint(covariant RewardIconPainter oldDelegate) => false;
}
