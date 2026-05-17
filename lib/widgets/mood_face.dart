import 'package:flutter/material.dart';

import '../models/mood.dart';
import '../painters/mood_face_painter.dart';

class MoodFace extends StatelessWidget {
  final Mood mood;
  final double size;
  final double strokeWidth;
  final bool filled;
  final Color? colorOverride;

  const MoodFace({
    super.key,
    required this.mood,
    this.size = 96,
    this.strokeWidth = 4.0,
    this.filled = true,
    this.colorOverride,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MoodFacePainter(
          mood: mood,
          color: colorOverride ?? mood.accentColor,
          strokeWidth: strokeWidth,
          filled: filled,
        ),
      ),
    );
  }
}
