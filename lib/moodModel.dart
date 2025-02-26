
import 'package:flutter/material.dart';

class Mood {
  final String emoji;
  final String label;
  final Color color;

  const Mood({
    required this.emoji,
    required this.label,
    required this.color,
  });
}
enum MoodKey { happy, content, neutral, sad, anxious }

final Map<MoodKey, Mood> moods = {
  MoodKey.happy: Mood(emoji: '😃', label: 'Happy', color: Colors.yellow),
  MoodKey.content: Mood(emoji: '🙂', label: 'Content', color: Colors.green),
  MoodKey.neutral: Mood(emoji: '😐', label: 'Neutral', color: Colors.grey),
  MoodKey.sad: Mood(emoji: '🙁', label: 'Sad', color: Colors.blue),
  MoodKey.anxious: Mood(emoji: '😓', label: 'Anxious', color: Colors.purple),
};
