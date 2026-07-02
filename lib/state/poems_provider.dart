// lib/state/poems_provider.dart
//
// WHY THIS FILE EXISTS (read this one closely — it's the trickiest concept
// in the project for a Flutter beginner):
//
// Without a state manager, if WriteScreen creates a new poem, FeedScreen
// has no way of knowing about it — they're separate widgets with separate
// local state. Riverpod solves this by holding data *outside* any single
// widget, in a "provider". Any screen can "watch" it (rebuild automatically
// when it changes) or "read" it (grab the current value once, e.g. to
// modify it on a button tap).
//
// Think of it like a shared whiteboard that any screen can write on, and
// any screen can also just glance at and be notified when it changes.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poem.dart';

/// A StateNotifier holds a piece of state (here, `List<Poem>`) and exposes
/// methods to change it safely. Every time we call `state = ...`, Riverpod
/// tells every widget watching this provider to rebuild.
class PoemsNotifier extends StateNotifier<List<Poem>> {
  PoemsNotifier() : super(samplePoems);

  void addDraft({
    required String title,
    required String body,
    required String language,
  }) {
    final draft = Poem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'You',
      authorHandle: '@you',
      title: title.isEmpty ? 'Untitled' : title,
      body: body,
      language: language,
      timeAgo: 'edited just now',
      status: PoemStatus.draft,
    );
    state = [draft, ...state];
  }

  void publish(String poemId) {
    state = [
      for (final p in state)
        if (p.id == poemId) p.copyWith(status: PoemStatus.published) else p,
    ];
  }

  void toggleLike(String poemId) {
    state = [
      for (final p in state)
        if (p.id == poemId) p.copyWith(likes: p.likes + 1) else p,
    ];
  }
}

/// This is the actual provider other widgets import and use, e.g.:
///   final poems = ref.watch(poemsProvider);
final poemsProvider = StateNotifierProvider<PoemsNotifier, List<Poem>>(
  (ref) => PoemsNotifier(),
);

/// Small derived providers — Riverpod recomputes these automatically
/// whenever poemsProvider changes, so screens can just watch the slice
/// of data they care about instead of filtering manually every build.
final publishedPoemsProvider = Provider<List<Poem>>((ref) {
  final all = ref.watch(poemsProvider);
  return all.where((p) => p.status == PoemStatus.published).toList();
});

final draftPoemsProvider = Provider<List<Poem>>((ref) {
  final all = ref.watch(poemsProvider);
  return all.where((p) => p.status == PoemStatus.draft).toList();
});
