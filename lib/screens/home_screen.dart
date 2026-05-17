import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mood.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_selector.dart';
import '../widgets/timeline.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _justLoggedId;

  Future<void> _handleLog(Mood mood) async {
    final entry = await ref.read(moodEntriesProvider.notifier).logMood(mood);
    if (!mounted) return;
    setState(() => _justLoggedId = entry.id);
  }

  Future<void> _confirmClear() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all entries?'),
        content: const Text(
          'This will permanently delete every logged mood. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (shouldClear == true) {
      await ref.read(moodEntriesProvider.notifier).clear();
      if (mounted) setState(() => _justLoggedId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recent = ref.watch(recentEntriesProvider);
    final totalCount = ref.watch(moodEntriesProvider).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    totalCount: totalCount,
                    onClear: totalCount == 0 ? null : _confirmClear,
                  ),
                  const SizedBox(height: 32),
                  _Card(
                    title: 'How are you feeling right now?',
                    subtitle: 'Tap a face to log it.',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: MoodSelector(onSelect: _handleLog),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _Card(
                    title: 'Recent entries',
                    subtitle: recent.isEmpty
                        ? null
                        : 'Showing your last ${recent.length} of $totalCount. Tap any entry to replay it.',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Timeline(
                        entries: recent,
                        justLoggedId: _justLoggedId,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int totalCount;
  final VoidCallback? onClear;

  const _Header({required this.totalCount, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mood Tracker',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'A small daily check-in.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          ),
        ),
        if (onClear != null)
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Clear all'),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const _Card({required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}
