// lib/screens/my_poems_screen.dart
//
// "Keep · drafts & unfinished poems" from THE FLOW.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poem.dart';
import '../state/poems_provider.dart';
import '../theme/app_theme.dart';
import 'write_screen.dart';

class MyPoemsScreen extends ConsumerStatefulWidget {
  const MyPoemsScreen({super.key});

  @override
  ConsumerState<MyPoemsScreen> createState() => _MyPoemsScreenState();
}

// SingleTickerProviderStateMixin gives this State the "ticker" a TabController
// needs to drive its animations (sliding the underline, etc).
class _MyPoemsScreenState extends ConsumerState<MyPoemsScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drafts = ref.watch(draftPoemsProvider);
    final published = ref.watch(publishedPoemsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('My poems', style: AppFonts.english(size: 20, weight: FontWeight.w600)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.ink,
          unselectedLabelColor: AppColors.inkMuted,
          indicatorColor: AppColors.accent,
          labelStyle: AppFonts.ui(weight: FontWeight.w600),
          tabs: [
            Tab(text: 'Drafts · ${drafts.length}'),
            Tab(text: 'Published · ${published.length}'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PoemList(poems: drafts, emptyLabel: 'No drafts yet'),
          _PoemList(poems: published, emptyLabel: 'Nothing published yet'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WriteScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _PoemList extends StatelessWidget {
  final List<Poem> poems;
  final String emptyLabel;
  const _PoemList({required this.poems, required this.emptyLabel});

  @override
  Widget build(BuildContext context) {
    if (poems.isEmpty) {
      return Center(child: Text(emptyLabel, style: AppFonts.ui(color: AppColors.inkMuted)));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: poems.length,
      separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 28),
      itemBuilder: (context, i) {
        final poem = poems[i];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(poem.title,
                      style: AppFonts.forLanguage(poem.language,
                          size: 18, weight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    poem.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.forLanguage(poem.language,
                        size: 13, color: AppColors.inkMuted),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        poem.status == PoemStatus.draft ? 'Draft' : 'Published',
                        style: AppFonts.ui(
                          size: 11,
                          weight: FontWeight.w600,
                          color: poem.status == PoemStatus.draft
                              ? AppColors.accent
                              : AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('· ${poem.timeAgo}',
                          style: AppFonts.ui(size: 11, color: AppColors.inkMuted)),
                      if (poem.hasAudio) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.mic, size: 12, color: AppColors.inkMuted),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Text(poem.language == 'ne' ? 'ने' : 'EN',
                style: AppFonts.ui(size: 11, color: AppColors.inkMuted)),
          ],
        );
      },
    );
  }
}
