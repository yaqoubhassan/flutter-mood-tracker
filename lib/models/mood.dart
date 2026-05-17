import 'package:flutter/material.dart';

enum Mood {
  excited(label: 'Excited', accentColor: Color(0xFFF59E0B)),
  happy(label: 'Happy', accentColor: Color(0xFF10B981)),
  neutral(label: 'Neutral', accentColor: Color(0xFF6B7280)),
  sad(label: 'Sad', accentColor: Color(0xFF3B82F6)),
  angry(label: 'Angry', accentColor: Color(0xFFEF4444));

  final String label;
  final Color accentColor;

  const Mood({required this.label, required this.accentColor});
}
