import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/mood.dart';
import '../models/mood_entry.dart';

const _storageKey = 'mood_entries_v1';
const _uuid = Uuid();

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in main()');
});

class MoodEntriesNotifier extends StateNotifier<List<MoodEntry>> {
  final SharedPreferences _prefs;

  MoodEntriesNotifier(this._prefs) : super(const []) {
    _hydrate();
  }

  void _hydrate() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => MoodEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      state = list;
    } catch (_) {
      state = const [];
    }
  }

  Future<void> _persist() async {
    final payload = jsonEncode(state.map((e) => e.toJson()).toList());
    await _prefs.setString(_storageKey, payload);
  }

  Future<MoodEntry> logMood(Mood mood) async {
    final entry = MoodEntry(
      id: _uuid.v4(),
      mood: mood,
      timestamp: DateTime.now(),
    );
    state = [entry, ...state];
    await _persist();
    return entry;
  }

  Future<void> clear() async {
    state = const [];
    await _persist();
  }
}

final moodEntriesProvider =
    StateNotifierProvider<MoodEntriesNotifier, List<MoodEntry>>((ref) {
  return MoodEntriesNotifier(ref.watch(sharedPreferencesProvider));
});

final recentEntriesProvider = Provider<List<MoodEntry>>((ref) {
  return ref.watch(moodEntriesProvider).take(7).toList();
});
