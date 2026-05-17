import 'mood.dart';

class MoodEntry {
  final String id;
  final Mood mood;
  final DateTime timestamp;

  const MoodEntry({
    required this.id,
    required this.mood,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'mood': mood.name,
        'timestamp': timestamp.toIso8601String(),
      };

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    final moodName = json['mood'] as String;
    return MoodEntry(
      id: json['id'] as String,
      mood: Mood.values.firstWhere(
        (m) => m.name == moodName,
        orElse: () => Mood.neutral,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
