// lib/screens/feed_screen.dart
//
// This is direction "1a Reading list" from the mockup: editorial cards in
// a scrollable list, with a filter row up top (For you / नेपाली / English
// / Following).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/poems_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/poem_card.dart';
import 'poem_detail_screen.dart';

/// ConsumerStatefulWidget = a StatefulWidget that can also read Riverpod
/// providers. We need local State here just for "which filter chip is
/// selected" (`_filter`) — that doesn't need to be shared app-wide, so it
/// stays local instead of going in poems_provider.dart.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  String _filter = 'For you';
  final _filters = const ['For you', 'नेपाली', 'English', 'Following'];

  @override
  Widget build(BuildContext context) {
    // `ref.watch` subscribes this widget to poemsProvider: whenever the
    // list changes (a like, a new draft published, etc.) this build()
    // method re-runs automatically.
    final poems = ref.watch(publishedPoemsProvider);

    final visible = poems.where((p) {
      if (_filter == 'For you' || _filter == 'Following') return true;
      if (_filter == 'नेपाली') return p.language == 'ne';
      if (_filter == 'English') return p.language == 'en';
      return true;
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('For you',
                    style: AppFonts.english(size: 26, weight: FontWeight.w600)),
                const Icon(Icons.person_outline, color: AppColors.ink),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final label = _filters[i];
                final selected = label == _filter;
                return ChoiceChip(
                  label: Text(label),
                  labelStyle: AppFonts.ui(
                    color: selected ? Colors.white : AppColors.ink,
                    weight: FontWeight.w600,
                  ),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = label),
                  selectedColor: AppColors.ink,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: visible.length,
              itemBuilder: (context, i) {
                final poem = visible[i];
                return PoemCard(
                  poem: poem,
                  onLike: () => ref.read(poemsProvider.notifier).toggleLike(poem.id),
                  onTap: () {
                    // Navigator.push moves to a new screen and puts it on
                    // top of a "stack" — the back button/gesture pops it
                    // off again to return here.
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PoemDetailScreen(poem: poem)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
