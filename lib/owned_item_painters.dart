import 'package:flutter/material.dart';
import 'dart:math' as math;

// Public painters identical to the icons used on the Main Hub "Owned Items" grid.

class ItemStarPainter extends CustomPainter {
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

class ItemFlowerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);

    const Color strokeBrown = Color(0xFF6E5338);
    const Color potFill = Color(0xFFD6C9B5);
    const Color potBand = Color(0xFFC8B8A0);
    const Color stemGreen = Color(0xFF4E8A3B);
    const Color leafLight = Color(0xFF78A75A);
    const Color petalLight = Color(0xFFF7C1CF);
    const Color petalMid = Color(0xFFF2A5B5);
    const Color flowerCore = Color(0xFFF3DB6A);

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

    Path leafPath(Offset c, bool left) {
      final double dir = left ? -1 : 1;
      final double s = size.shortestSide;
      final Path p = Path()
        ..moveTo(c.dx, c.dy)
        ..cubicTo(
          c.dx + dir * (s * 0.11),
          c.dy - (s * 0.05),
          c.dx + dir * (s * 0.15),
          c.dy + (s * 0.09),
          c.dx + dir * (s * 0.07),
          c.dy + (s * 0.13),
        )
        ..cubicTo(
          c.dx + dir * (s * 0.015),
          c.dy + (s * 0.12),
          c.dx - dir * (s * 0.04),
          c.dy + (s * 0.07),
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
    canvas.drawPath(
      leafPath(Offset(leafCenter.dx - 10, leafCenter.dy), true),
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    canvas.drawPath(
      leafPath(Offset(leafCenter.dx + 10, leafCenter.dy), false),
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

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

class ItemButterflyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h * 0.50);

    const Color strokeBrown = Color(0xFF6E5338);
    const Color wingLight = Color(0xFFD1EAFE);
    const Color wingMid = Color(0xFFAED6FB);
    const Color wingDark = Color(0xFF7FBFF1);
    const Color bodyDark = Color(0xFF6B4E3A);
    const Color spot = Color(0xFFF6F6F6);

    final Color outlineLight = Colors.white; // contrast halo

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

    final RRect lu = wingOval(Offset(c.dx - wingOX, c.dy - wingOY), upperWing);
    canvas.drawRRect(lu, wingFill(lu.outerRect));
    // light halo then dark stroke
    canvas.drawRRect(
      lu,
      Paint()
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0,
    );
    canvas.drawRRect(
      lu,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    final RRect ll = wingOval(
      Offset(c.dx - wingOX + w * 0.04, c.dy + wingOY),
      lowerWing,
    );
    canvas.drawRRect(ll, wingFill(ll.outerRect));
    canvas.drawRRect(
      ll,
      Paint()
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0,
    );
    canvas.drawRRect(
      ll,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    final RRect ru = wingOval(Offset(c.dx + wingOX, c.dy - wingOY), upperWing);
    canvas.drawRRect(ru, wingFill(ru.outerRect));
    canvas.drawRRect(
      ru,
      Paint()
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0,
    );
    canvas.drawRRect(
      ru,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    final RRect rl = wingOval(
      Offset(c.dx + wingOX - w * 0.04, c.dy + wingOY),
      lowerWing,
    );
    canvas.drawRRect(rl, wingFill(rl.outerRect));
    canvas.drawRRect(
      rl,
      Paint()
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0,
    );
    canvas.drawRRect(
      rl,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

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
    canvas.drawRRect(
      body,
      Paint()
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
    canvas.drawCircle(
      Offset(c.dx, bodyRect.top - h * 0.02),
      w * 0.04,
      Paint()..color = bodyDark,
    );
    canvas.drawCircle(
      Offset(c.dx, bodyRect.top - h * 0.02),
      w * 0.04,
      Paint()
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    final Paint antLight = Paint()
      ..color = outlineLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..strokeCap = StrokeCap.round;

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
    // draw halo then antenna
    canvas.drawPath(al, antLight);
    canvas.drawPath(ar, antLight);
    canvas.drawPath(al, ant);
    canvas.drawPath(ar, ant);

    void spotCircle(Offset o, double r) {
      canvas.drawCircle(o, r, Paint()..color = spot.withOpacity(0.95));
    }

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

class ItemBowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h * 0.52);

    const Color strokeBrown = Color(0xFF6E5338);
    const Color bowLight = Color(0xFFF1A29A);
    const Color bowMid = Color(0xFFE07D73);
    const Color bowDark = Color(0xFFCC6B60);
    final Color outlineLight = Colors.white;

    Paint fillFor(Path path) {
      final Rect r = path.getBounds();
      return Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [bowLight, bowMid, bowDark],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(r);
    }

    final RRect knot = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: c.translate(0, -h * 0.02),
        width: w * 0.20,
        height: h * 0.16,
      ),
      Radius.circular(w * 0.06),
    );

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

    for (final Path p in [left, right, leftTail, rightTail]) {
      canvas.drawPath(p, fillFor(p));
      canvas.drawPath(
        p,
        Paint()
          ..color = outlineLight
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeJoin = StrokeJoin.round,
      );
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
        ..color = outlineLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );
    canvas.drawRRect(
      knot,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

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
  void paint(Canvas canvas, Size size) => ItemStarPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FlowerItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      ItemFlowerPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ButterflyItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) =>
      ItemButterflyPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BowItemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) => ItemBowPainter().paint(canvas, size);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
