import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'timeline_entry_card.dart';

class Timeline extends StatelessWidget {
  final List<MoodEntry> entries;
  final String? justLoggedId;

  const Timeline({
    super.key,
    required this.entries,
    this.justLoggedId,
  });

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const _EmptyState();

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return TimelineEntryCard(
            key: ValueKey(entry.id),
            entry: entry,
            autoPlay: entry.id == justLoggedId,
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Text(
        'No entries yet. Tap a face above to log your first mood.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
            ),
      ),
    );
  }
}
