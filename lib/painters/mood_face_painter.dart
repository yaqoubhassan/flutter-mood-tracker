import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/mood.dart';

class MoodFacePainter extends CustomPainter {
  final Mood mood;
  final Color color;
  final double strokeWidth;
  final bool filled;

  const MoodFacePainter({
    required this.mood,
    required this.color,
    this.strokeWidth = 4.0,
    this.filled = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.92;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (filled) {
      final fill = Paint()
        ..color = color.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, fill);
    }

    canvas.drawCircle(center, radius, stroke);

    switch (mood) {
      case Mood.excited:
        _drawExcited(canvas, center, radius, stroke);
      case Mood.happy:
        _drawHappy(canvas, center, radius, stroke);
      case Mood.neutral:
        _drawNeutral(canvas, center, radius, stroke);
      case Mood.sad:
        _drawSad(canvas, center, radius, stroke);
      case Mood.angry:
        _drawAngry(canvas, center, radius, stroke);
    }
  }

  void _drawExcited(Canvas canvas, Offset c, double r, Paint p) {
    _drawWideOpenEyes(canvas, c, r, p);
    _drawCurvedEyebrows(canvas, c, r, p, EyebrowShape.raised);

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.32),
      width: r * 0.55,
      height: r * 0.45,
    );
    final mouthFill = Paint()
      ..color = p.color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawOval(mouthRect, mouthFill);
    canvas.drawOval(mouthRect, p);
  }

  void _drawHappy(Canvas canvas, Offset c, double r, Paint p) {
    _drawDotEyes(canvas, c, r, p);

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.18),
      width: r * 0.85,
      height: r * 0.55,
    );
    canvas.drawArc(mouthRect, 0, math.pi, false, p);
  }

  void _drawNeutral(Canvas canvas, Offset c, double r, Paint p) {
    _drawDotEyes(canvas, c, r, p);

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.42),
      width: r * 0.7,
      height: r * 0.04,
    );
    canvas.drawArc(mouthRect, 0, math.pi, false, p);
  }

  void _drawSad(Canvas canvas, Offset c, double r, Paint p) {
    _drawDotEyes(canvas, c, r, p);
    _drawCurvedEyebrows(canvas, c, r, p, EyebrowShape.worried);

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.6),
      width: r * 0.75,
      height: r * 0.5,
    );
    canvas.drawArc(mouthRect, math.pi, math.pi, false, p);
  }

  void _drawAngry(Canvas canvas, Offset c, double r, Paint p) {
    _drawDotEyes(canvas, c, r, p);
    _drawCurvedEyebrows(canvas, c, r, p, EyebrowShape.angry);

    final mouthRect = Rect.fromCenter(
      center: Offset(c.dx, c.dy + r * 0.55),
      width: r * 0.6,
      height: r * 0.35,
    );
    canvas.drawArc(mouthRect, math.pi, math.pi, false, p);
  }

  void _drawDotEyes(Canvas canvas, Offset c, double r, Paint p) {
    final eyeY = c.dy - r * 0.22;
    final offsetX = r * 0.32;
    final eyeRadius = r * 0.075;

    final fill = Paint()
      ..color = p.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(c.dx - offsetX, eyeY), eyeRadius, fill);
    canvas.drawCircle(Offset(c.dx + offsetX, eyeY), eyeRadius, fill);
  }

  void _drawWideOpenEyes(Canvas canvas, Offset c, double r, Paint p) {
    final eyeY = c.dy - r * 0.22;
    final offsetX = r * 0.32;
    final outerRadius = r * 0.12;
    final pupilRadius = r * 0.05;

    final pupilPaint = Paint()
      ..color = p.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(c.dx - offsetX, eyeY), outerRadius, p);
    canvas.drawCircle(Offset(c.dx + offsetX, eyeY), outerRadius, p);
    canvas.drawCircle(Offset(c.dx - offsetX, eyeY), pupilRadius, pupilPaint);
    canvas.drawCircle(Offset(c.dx + offsetX, eyeY), pupilRadius, pupilPaint);
  }

  void _drawCurvedEyebrows(
    Canvas canvas,
    Offset c,
    double r,
    Paint p,
    EyebrowShape shape,
  ) {
    final baseY = c.dy - r * 0.48;
    final halfWidth = r * 0.18;
    final offsetX = r * 0.32;

    canvas.drawPath(
      _eyebrowPath(
        center: Offset(c.dx - offsetX, baseY),
        halfWidth: halfWidth,
        shape: shape,
        isLeft: true,
        r: r,
      ),
      p,
    );
    canvas.drawPath(
      _eyebrowPath(
        center: Offset(c.dx + offsetX, baseY),
        halfWidth: halfWidth,
        shape: shape,
        isLeft: false,
        r: r,
      ),
      p,
    );
  }

  Path _eyebrowPath({
    required Offset center,
    required double halfWidth,
    required EyebrowShape shape,
    required bool isLeft,
    required double r,
  }) {
    // Positive tilt drops the inner corner (angry); negative lifts it (worried).
    final tilt = r * 0.09;
    final double innerY;
    final double outerY;
    final double controlOffset;

    switch (shape) {
      case EyebrowShape.raised:
        innerY = center.dy;
        outerY = center.dy;
        controlOffset = -r * 0.06;
      case EyebrowShape.worried:
        innerY = center.dy - tilt;
        outerY = center.dy + tilt * 0.4;
        controlOffset = -r * 0.02;
      case EyebrowShape.angry:
        innerY = center.dy + tilt;
        outerY = center.dy - tilt * 0.6;
        controlOffset = r * 0.02;
    }

    final innerX = isLeft ? center.dx + halfWidth : center.dx - halfWidth;
    final outerX = isLeft ? center.dx - halfWidth : center.dx + halfWidth;

    return Path()
      ..moveTo(outerX, outerY)
      ..quadraticBezierTo(
        center.dx,
        ((innerY + outerY) / 2) + controlOffset,
        innerX,
        innerY,
      );
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter old) =>
      old.mood != mood ||
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.filled != filled;
}

enum EyebrowShape { raised, worried, angry }
