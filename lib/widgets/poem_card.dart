// lib/widgets/poem_card.dart
//
// WHY THIS FILE EXISTS:
// The feed shows many poems, each rendered identically. Rather than
// copy-pasting the same Column/Row layout for every poem, we make a single
// PoemCard widget that takes a Poem and draws it. This is the core Flutter
// habit: "widgets are just functions of data." Same input -> same look,
// every time.

import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../theme/app_theme.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const PoemCard({
    super.key,
    required this.poem,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- author row ---
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.accentSoft,
                  child: Text(
                    poem.authorName.characters.first,
                    style: AppFonts.ui(
                        size: 12, weight: FontWeight.w600, color: AppColors.accent),
                  ),
                ),
                const SizedBox(width: 8),
                Text(poem.authorName, style: AppFonts.ui(weight: FontWeight.w600)),
                const SizedBox(width: 6),
                Text(poem.timeAgo,
                    style: AppFonts.ui(size: 12, color: AppColors.inkMuted)),
                const Spacer(),
                _LanguageTag(language: poem.language),
              ],
            ),
            const SizedBox(height: 12),

            // --- title ---
            Text(
              poem.title,
              style: AppFonts.forLanguage(poem.language,
                  size: 20, weight: FontWeight.w600),
            ),
            const SizedBox(height: 6),

            // --- body preview, max 3 lines so cards stay a consistent
            //     height in the list ---
            Text(
              poem.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.forLanguage(poem.language,
                  size: 15, color: AppColors.ink.withValues(alpha: 0.85), height: 1.4),
            ),

            if (poem.hasAudio) ...[
              const SizedBox(height: 12),
              _AudioChip(duration: poem.audioDuration ?? ''),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                _IconCount(
                  icon: Icons.favorite_border,
                  count: poem.likes,
                  onTap: onLike,
                ),
                const SizedBox(width: 18),
                _IconCount(icon: Icons.chat_bubble_outline, count: poem.comments),
                const Spacer(),
                const Icon(Icons.ios_share, size: 18, color: AppColors.inkMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTag extends StatelessWidget {
  final String language;
  const _LanguageTag({required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        language == 'ne' ? 'नेपाली' : 'EN',
        style: AppFonts.ui(size: 11, weight: FontWeight.w600, color: AppColors.accent),
      ),
    );
  }
}

class _AudioChip extends StatelessWidget {
  final String duration;
  const _AudioChip({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_arrow_rounded, size: 20, color: AppColors.accent),
          const SizedBox(width: 6),
          // A cheap fake waveform — a row of bars of random-ish heights.
          Expanded(
            child: SizedBox(
              height: 16,
              child: Row(
                children: List.generate(24, (i) {
                  final h = 4.0 + (i % 5) * 2.5;
                  return Container(
                    width: 2,
                    height: h,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    color: AppColors.inkMuted.withValues(alpha: 0.5),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(duration, style: AppFonts.ui(size: 12, color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _IconCount extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback? onTap;
  const _IconCount({required this.icon, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.inkMuted),
            const SizedBox(width: 4),
            Text('$count', style: AppFonts.ui(size: 13, color: AppColors.inkMuted)),
          ],
        ),
      ),
    );
  }
}
