import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mood_tracker/models/mood.dart';
import 'package:mood_tracker/painters/mood_face_painter.dart';
import 'package:mood_tracker/widgets/mood_face.dart';

void main() {
  group('MoodFacePainter', () {
    test('shouldRepaint returns true when mood changes', () {
      const a = MoodFacePainter(mood: Mood.happy, color: Colors.green);
      const b = MoodFacePainter(mood: Mood.sad, color: Colors.green);
      expect(b.shouldRepaint(a), isTrue);
    });

    test('shouldRepaint returns false when nothing changes', () {
      const a = MoodFacePainter(mood: Mood.happy, color: Colors.green);
      const b = MoodFacePainter(mood: Mood.happy, color: Colors.green);
      expect(b.shouldRepaint(a), isFalse);
    });
  });

  group('MoodFace widget', () {
    testWidgets('renders a CustomPaint for every mood', (tester) async {
      for (final mood in Mood.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: Center(child: MoodFace(mood: mood))),
          ),
        );
        expect(find.byType(CustomPaint), findsWidgets);
      }
    });
  });
}
