import 'package:flutter/material.dart';

import '../models/mood.dart';
import 'mood_face.dart';

class MoodSelector extends StatelessWidget {
  final void Function(Mood mood) onSelect;

  const MoodSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 520;

        final buttons = Mood.values
            .map((m) => _MoodButton(mood: m, onTap: () => onSelect(m)))
            .toList();

        if (isNarrow) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                for (final b in buttons)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: b,
                  ),
              ],
            ),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons,
        );
      },
    );
  }
}

class _MoodButton extends StatefulWidget {
  final Mood mood;
  final VoidCallback onTap;

  const _MoodButton({required this.mood, required this.onTap});

  @override
  State<_MoodButton> createState() => _MoodButtonState();
}

class _MoodButtonState extends State<_MoodButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovering ? 1.06 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MoodFace(mood: widget.mood, size: 76),
              const SizedBox(height: 8),
              Text(
                widget.mood.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: widget.mood.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
