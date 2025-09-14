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

// Calendar with check mark icon for weekly quests
class CalendarCheckIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Outer rounded rect background (paper color)
    final RRect bg = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bg, Paint()..color = const Color(0xFFFFFBEE));

    // Calendar body
    final double pad = w * 0.12;
    final RRect body = RRect.fromRectAndRadius(
      Rect.fromLTWH(pad, pad * 1.3, w - pad * 2, h - pad * 2.1),
      Radius.circular(w * 0.1),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFFF6E7C7));
    canvas.drawRRect(
      body,
      Paint()
        ..color = const Color(0xFFBE9E6A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Top bar (red)
    final Rect topBar = Rect.fromLTWH(
      body.left,
      body.top - w * 0.16,
      body.width,
      w * 0.22,
    );
    final RRect topR = RRect.fromRectAndCorners(
      topBar,
      topLeft: Radius.circular(w * 0.10),
      topRight: Radius.circular(w * 0.10),
    );
    canvas.drawRRect(topR, Paint()..color = const Color(0xFFD46A60));
    canvas.drawRRect(
      topR,
      Paint()
        ..color = const Color(0xFF9C4C44)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // Binder rings
    final Paint ring = Paint()..color = const Color(0xFFBE9E6A);
    final double ringR = w * 0.045;
    canvas.drawCircle(
      Offset(topBar.left + ringR * 2, topBar.top + ringR),
      ringR,
      ring,
    );
    canvas.drawCircle(
      Offset(topBar.right - ringR * 2, topBar.top + ringR),
      ringR,
      ring,
    );

    // Page fold corner
    final Path corner = Path()
      ..moveTo(body.right - w * 0.12, body.bottom)
      ..lineTo(body.right, body.bottom)
      ..lineTo(body.right, body.bottom - w * 0.12)
      ..close();
    canvas.drawPath(corner, Paint()..color = const Color(0xFFEBD9B3));
    canvas.drawPath(
      corner,
      Paint()
        ..color = const Color(0xFFBE9E6A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // Check mark (gold)
    final Paint check = Paint()
      ..color = const Color(0xFFD6B765)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = w * 0.10;
    final Path checkPath = Path()
      ..moveTo(body.left + body.width * 0.26, body.top + body.height * 0.54)
      ..lineTo(body.left + body.width * 0.44, body.top + body.height * 0.70)
      ..lineTo(body.left + body.width * 0.74, body.top + body.height * 0.38);
    canvas.drawPath(checkPath, check);
  }

  @override
  bool shouldRepaint(covariant CalendarCheckIconPainter oldDelegate) => false;
}

// Streak chain with flame icon for streak quests (simple variant)
class StreakChainFlameIconPainterSimple extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Background paper
    final RRect bg = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bg, Paint()..color = const Color(0xFFFFFBEE));

    // Flame behind
    final Path flame = Path()
      ..moveTo(w * 0.30, h * 0.75)
      ..cubicTo(w * 0.26, h * 0.58, w * 0.30, h * 0.42, w * 0.46, h * 0.28)
      ..cubicTo(w * 0.54, h * 0.40, w * 0.64, h * 0.38, w * 0.70, h * 0.30)
      ..cubicTo(w * 0.72, h * 0.48, w * 0.68, h * 0.64, w * 0.56, h * 0.78)
      ..quadraticBezierTo(w * 0.50, h * 0.86, w * 0.30, h * 0.75)
      ..close();
    canvas.drawPath(flame, Paint()..color = const Color(0xFFFFD27A));
    canvas.drawPath(
      flame,
      Paint()
        ..color = const Color(0xFFCC8B3E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Chain links (gold)
    final Paint linkStroke = Paint()
      ..color = const Color(0xFFBE9E6A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08;
    final Paint linkFill = Paint()..color = const Color(0xFFE6C982);

    // Left link
    final RRect leftLink = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.42, h * 0.58),
        width: w * 0.36,
        height: h * 0.26,
      ),
      Radius.circular(w * 0.18),
    );
    // Right link
    final RRect rightLink = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.64, h * 0.48),
        width: w * 0.36,
        height: h * 0.26,
      ),
      Radius.circular(w * 0.18),
    );

    // Draw links
    canvas.drawRRect(leftLink, linkFill);
    canvas.drawRRect(rightLink, linkFill);
    canvas.drawRRect(leftLink, linkStroke);
    canvas.drawRRect(rightLink, linkStroke);

    // Overlap connector (gives interlocked feel)
    final Path overlap = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.53, h * 0.53), radius: w * 0.10),
      );
    canvas.drawPath(overlap, Paint()..color = const Color(0xFFE6C982));
    canvas.drawPath(
      overlap,
      Paint()
        ..color = const Color(0xFFBE9E6A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.04,
    );
  }

  @override
  bool shouldRepaint(covariant StreakChainFlameIconPainterSimple oldDelegate) =>
      false;
}

// Streak icon: golden chain over flame
class StreakChainFlameIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Flame behind
    const Color flameLight = Color(0xFFFFC26A);
    const Color flameMid = Color(0xFFFF9B42);
    const Color flameDark = Color(0xFFEB7A2E);
    const Color strokeBrown = Color(0xFFBE9E6A);

    Path flamePath() {
      final Path p = Path();
      final double cx = w * 0.42;
      final double cy = h * 0.56;
      p.moveTo(cx, h * 0.15);
      p.cubicTo(w * 0.20, h * 0.30, w * 0.20, h * 0.62, cx, cy);
      p.cubicTo(w * 0.54, h * 0.70, w * 0.70, h * 0.64, w * 0.78, h * 0.48);
      p.cubicTo(w * 0.66, h * 0.48, w * 0.60, h * 0.40, w * 0.60, h * 0.32);
      p.cubicTo(w * 0.56, h * 0.38, w * 0.48, h * 0.40, w * 0.44, h * 0.34);
      p.cubicTo(w * 0.46, h * 0.26, w * 0.46, h * 0.20, cx, h * 0.15);
      p.close();
      return p;
    }

    final Path flame = flamePath();
    final Rect flameBounds = flame.getBounds();
    final Paint flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [flameLight, flameMid, flameDark],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(flameBounds);
    canvas.drawPath(flame, flamePaint);
    canvas.drawPath(
      flame,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Coin/badge on the right bottom
    const Color coinLight = Color(0xFFFFE7A6);
    const Color coinMid = Color(0xFFE6C16B);
    const Color coinDark = Color(0xFFD4AF37);

    final double coinR = w * 0.24;
    final Offset coinC = Offset(w * 0.68, h * 0.68);
    final Rect coinRect = Rect.fromCircle(center: coinC, radius: coinR);
    final Paint coinFill = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 1.2,
        colors: const [coinLight, coinMid, coinDark],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(coinRect);
    canvas.drawCircle(coinC, coinR, coinFill);
    canvas.drawCircle(
      coinC,
      coinR,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Inner inset ring
    canvas.drawCircle(
      coinC,
      coinR * 0.72,
      Paint()
        ..color = coinDark.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Specular highlight
    canvas.drawCircle(
      Offset(coinC.dx - coinR * 0.34, coinC.dy - coinR * 0.34),
      coinR * 0.22,
      Paint()..color = Colors.white.withOpacity(0.28),
    );
  }

  @override
  bool shouldRepaint(covariant StreakChainFlameIconPainter oldDelegate) =>
      false;
}

// Pure flame icon used for streak quests
class StreakFlameIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Background paper
    final RRect bg = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bg, Paint()..color = const Color(0xFFFFFBEE));

    // Flame
    const Color flameLight = Color(0xFFFFF2A6);
    const Color flameMid = Color(0xFFFFC26A);
    const Color flameDark = Color(0xFFEB7A2E);
    const Color strokeBrown = Color(0xFFBE9E6A);

    Path flamePath() {
      final Path p = Path();
      final double cx = w * 0.50;
      // Outer silhouette with sharper tip and two lobes
      p.moveTo(cx, h * 0.08);
      p.cubicTo(w * 0.30, h * 0.26, w * 0.26, h * 0.56, cx, h * 0.78);
      p.cubicTo(w * 0.70, h * 0.70, w * 0.78, h * 0.54, w * 0.80, h * 0.38);
      p.cubicTo(w * 0.64, h * 0.42, w * 0.58, h * 0.32, w * 0.58, h * 0.22);
      p.cubicTo(w * 0.52, h * 0.30, w * 0.46, h * 0.30, cx, h * 0.20);
      p.close();
      return p;
    }

    final Path flame = flamePath();
    final Rect flameBounds = flame.getBounds();
    final Paint flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [flameLight, flameMid, flameDark],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(flameBounds);
    canvas.drawPath(flame, flamePaint);
    canvas.drawPath(
      flame,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Inner small flame with rounded bottom
    final Path inner = Path()
      ..moveTo(w * 0.50, h * 0.26)
      ..cubicTo(w * 0.44, h * 0.34, w * 0.42, h * 0.50, w * 0.50, h * 0.62)
      ..cubicTo(w * 0.58, h * 0.58, w * 0.62, h * 0.50, w * 0.62, h * 0.42)
      ..cubicTo(w * 0.58, h * 0.44, w * 0.56, h * 0.38, w * 0.56, h * 0.34)
      ..cubicTo(w * 0.54, h * 0.38, w * 0.52, h * 0.38, w * 0.50, h * 0.26)
      ..close();
    final Paint innerFill = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 1.0,
        colors: const [Color(0xFFFFF9C4), Color(0xFFFFE082)],
        stops: const [0.0, 1.0],
      ).createShader(inner.getBounds());
    canvas.drawPath(inner, innerFill);
    canvas.drawPath(
      inner,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    // Rim glow
    canvas.drawPath(
      flame,
      Paint()
        ..shader = LinearGradient(
          colors: [Colors.white.withOpacity(0.18), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(flameBounds)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(covariant StreakFlameIconPainter oldDelegate) => false;
}

// Stylized flame icon matching the provided image
class StreakChainIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Background paper
    final RRect bg = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bg, Paint()..color = const Color(0xFFFFFBEE));

    // Flame colors (matching the provided image)
    const Color flameYellow = Color(0xFFFFF3A8);
    const Color flameOrange = Color(0xFFFFB366);
    const Color flameDark = Color(0xFFE6965A);
    const Color strokeBrown = Color(0xFF8B5A2B);

    final double centerX = w * 0.5;

    // Create flame path
    final Path flamePath = Path();

    // Start from bottom center
    flamePath.moveTo(centerX, h * 0.8);

    // Left side of flame
    flamePath.quadraticBezierTo(
      w * 0.25,
      h * 0.7, // control point
      w * 0.3,
      h * 0.5, // end point
    );

    // Left flame tip
    flamePath.quadraticBezierTo(
      w * 0.2,
      h * 0.35, // control point
      w * 0.35,
      h * 0.25, // end point
    );

    // Top curve (main flame peak)
    flamePath.quadraticBezierTo(
      w * 0.45,
      h * 0.15, // control point
      centerX,
      h * 0.2, // peak
    );

    // Right top curve
    flamePath.quadraticBezierTo(
      w * 0.55,
      h * 0.15, // control point
      w * 0.65,
      h * 0.25, // end point
    );

    // Right flame tip
    flamePath.quadraticBezierTo(
      w * 0.8,
      h * 0.35, // control point
      w * 0.7,
      h * 0.5, // end point
    );

    // Right side back to bottom
    flamePath.quadraticBezierTo(
      w * 0.75,
      h * 0.7, // control point
      centerX,
      h * 0.8, // back to start
    );

    flamePath.close();

    // Create gradient for flame
    final Rect flameRect = flamePath.getBounds();
    final Paint flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [flameYellow, flameOrange, flameDark],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(flameRect);

    // Draw flame
    canvas.drawPath(flamePath, flamePaint);

    // Inner flame details
    final Path innerFlamePath = Path();
    innerFlamePath.moveTo(centerX, h * 0.75);
    innerFlamePath.quadraticBezierTo(w * 0.4, h * 0.6, w * 0.42, h * 0.45);
    innerFlamePath.quadraticBezierTo(w * 0.35, h * 0.35, w * 0.45, h * 0.3);
    innerFlamePath.quadraticBezierTo(w * 0.5, h * 0.25, w * 0.55, h * 0.3);
    innerFlamePath.quadraticBezierTo(w * 0.65, h * 0.35, w * 0.58, h * 0.45);
    innerFlamePath.quadraticBezierTo(w * 0.6, h * 0.6, centerX, h * 0.75);
    innerFlamePath.close();

    // Inner flame gradient
    final Paint innerFlamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Color(0xFFFFFDE4), flameYellow],
        stops: const [0.0, 1.0],
      ).createShader(innerFlamePath.getBounds());

    canvas.drawPath(innerFlamePath, innerFlamePaint);

    // Stroke outline
    canvas.drawPath(
      flamePath,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant StreakChainIconPainter oldDelegate) => false;
}
