import 'package:flutter/material.dart';

// Simple painter for the 'daily5' badge
class Daily5BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h / 2);

    // Colors
    const Color ringOuter = Color(0xFFCFD3DA); // silver outer
    const Color ringInner = Color(0xFFE8EBF0);
    const Color ringStroke = Color(0xFF8A8F98);
    const Color leaf = Color(0xFF8BA870);
    const Color calBody = Color(0xFFF2D08A); // gold
    const Color calStroke = Color(0xFF8B6B47);

    // Ring
    final double outerR = w * 0.48;
    final double innerR = w * 0.40;
    canvas.drawCircle(c, outerR, Paint()..color = ringOuter);
    canvas.drawCircle(c, innerR, Paint()..color = ringInner);
    canvas.drawCircle(
      c,
      outerR,
      Paint()
        ..color = ringStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    // Laurel leaves (left & right)
    Path laurel(bool right) {
      final double dir = right ? 1 : -1;
      final Path p = Path();
      p.moveTo(c.dx + dir * w * 0.18, c.dy + h * 0.02);
      p.cubicTo(
        c.dx + dir * w * 0.26,
        c.dy - h * 0.02,
        c.dx + dir * w * 0.26,
        c.dy + h * 0.12,
        c.dx + dir * w * 0.18,
        c.dy + h * 0.10,
      );
      return p;
    }

    final Paint leafPaint = Paint()
      ..color = leaf
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(laurel(false), leafPaint);
    canvas.drawPath(laurel(true), leafPaint);

    // Calendar body
    final RRect cal = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: c.translate(0, h * 0.02),
        width: w * 0.36,
        height: h * 0.30,
      ),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(cal, Paint()..color = calBody);
    canvas.drawRRect(
      cal,
      Paint()
        ..color = calStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Calendar rings at top
    for (int i = -1; i <= 1; i++) {
      canvas.drawCircle(
        c.translate(i * w * 0.06, -h * 0.09),
        w * 0.018,
        Paint()..color = calStroke,
      );
    }

    // Small squares/dots inside calendar
    final Paint cell = Paint()..color = calStroke.withOpacity(0.65);
    for (int r = 0; r < 2; r++) {
      for (int col = 0; col < 3; col++) {
        final Offset o = c.translate(
          (col - 1) * w * 0.06,
          (r == 0 ? 0.0 : h * 0.06) - h * 0.01,
        );
        canvas.drawCircle(o, w * 0.012, cell);
      }
    }
    // Center mark
    canvas.drawCircle(c.translate(0, h * 0.035), w * 0.018, cell);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Weekly3 badge: golden ring with interlocked chain links
class Weekly3BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h / 2);

    // Colors (golden)
    const Color goldLight = Color(0xFFFFE6A9);
    const Color goldMid = Color(0xFFE6C16B);
    const Color goldDark = Color(0xFFB79A55);
    const Color strokeBrown = Color(0xFF6E5338);

    // Outer ring
    final double outerR = w * 0.48;
    final double innerR = w * 0.40;
    final Paint ringFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [goldLight, goldMid, goldDark],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: outerR));
    canvas.drawCircle(c, outerR, ringFill);
    canvas.drawCircle(
      c,
      outerR,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    // Punch inner hole to create ring effect
    canvas.drawCircle(c, innerR, Paint()..blendMode = BlendMode.clear);
    canvas.saveLayer(Offset.zero & size, Paint());

    // Interlocked links
    RRect linkRRect(Offset center, Size s, double r) => RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: s.width, height: s.height),
      Radius.circular(r),
    );

    void drawLink(Offset center, Size s, double r, double angle) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.translate(-center.dx, -center.dy);

      final RRect outer = linkRRect(center, s, r);
      final RRect inner = linkRRect(
        center,
        Size(s.width * 0.64, s.height * 0.64),
        r * 0.64,
      );
      final Path ring = Path()
        ..addRRect(outer)
        ..addRRect(inner)
        ..fillType = PathFillType.evenOdd;
      final Rect bounds = outer.outerRect;
      final Paint fill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [Colors.white, goldMid, goldDark],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(bounds);
      canvas.drawPath(ring, fill);
      canvas.drawRRect(
        outer,
        Paint()
          ..color = strokeBrown
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
      canvas.restore();
    }

    final Size linkSize = Size(w * 0.48, h * 0.26);
    final double radius = linkSize.height * 0.46;
    drawLink(
      c.translate(w * 0.06, h * 0.06),
      linkSize,
      radius,
      -0.36,
    ); // back-left
    drawLink(
      c.translate(-w * 0.06, -h * 0.06),
      linkSize,
      radius,
      0.40,
    ); // front-right

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Streak1 badge: golden ring with a torch and flame
class Streak1BadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset c = Offset(w / 2, h / 2);

    // Colors
    const Color goldLight = Color(0xFFFFE6A9);
    const Color goldMid = Color(0xFFE6C16B);
    const Color goldDark = Color(0xFFB79A55);
    const Color strokeBrown = Color(0xFF6E5338);
    const Color flameYellow = Color(0xFFFFF3A8);
    const Color flameOrange = Color(0xFFFFB366);
    const Color flameDark = Color(0xFFE6965A);

    // Ring
    final double outerR = w * 0.48;
    final double innerR = w * 0.40;
    final Paint ringFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [goldLight, goldMid, goldDark],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: outerR));
    canvas.drawCircle(c, outerR, ringFill);
    canvas.drawCircle(
      c,
      outerR,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    canvas.drawCircle(c, innerR, Paint()..blendMode = BlendMode.clear);
    canvas.saveLayer(Offset.zero & size, Paint());

    // Torch handle
    final double handleW = w * 0.14;
    final double handleH = h * 0.30;
    final RRect handle = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: c.translate(0, h * 0.16),
        width: handleW,
        height: handleH,
      ),
      Radius.circular(handleW * 0.35),
    );
    final Paint handleFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [goldLight, goldDark],
      ).createShader(handle.outerRect);
    canvas.drawRRect(handle, handleFill);
    canvas.drawRRect(
      handle,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Torch cup
    final RRect cup = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: c.translate(0, h * 0.02),
        width: w * 0.26,
        height: h * 0.14,
      ),
      Radius.circular(w * 0.04),
    );
    final Paint cupFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [goldLight, goldMid],
      ).createShader(cup.outerRect);
    canvas.drawRRect(cup, cupFill);
    canvas.drawRRect(
      cup,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Flame
    final Path flamePath = Path()
      ..moveTo(c.dx, c.dy - h * 0.20)
      ..quadraticBezierTo(
        c.dx - w * 0.10,
        c.dy - h * 0.18,
        c.dx - w * 0.08,
        c.dy - h * 0.08,
      )
      ..quadraticBezierTo(
        c.dx - w * 0.04,
        c.dy - h * 0.02,
        c.dx,
        c.dy - h * 0.02,
      )
      ..quadraticBezierTo(
        c.dx + w * 0.04,
        c.dy - h * 0.02,
        c.dx + w * 0.08,
        c.dy - h * 0.08,
      )
      ..quadraticBezierTo(
        c.dx + w * 0.10,
        c.dy - h * 0.18,
        c.dx,
        c.dy - h * 0.20,
      )
      ..close();
    final Rect fBounds = flamePath.getBounds();
    final Paint flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [flameYellow, flameOrange, flameDark],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(fBounds);
    canvas.drawPath(flamePath, flamePaint);
    canvas.drawPath(
      flamePath,
      Paint()
        ..color = strokeBrown
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
