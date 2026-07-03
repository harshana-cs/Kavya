// lib/screens/poem_detail_screen.dart
//
// This is the "Poem · react, comment, share, listen" screen from THE FLOW.
// It's a plain StatefulWidget (not Consumer) because everything on this
// screen — which language tab is active, the comment list — is local to
// this one screen and doesn't need to be shared elsewhere.

import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../theme/app_theme.dart';

class PoemDetailScreen extends StatefulWidget {
  final Poem poem;
  const PoemDetailScreen({super.key, required this.poem});

  @override
  State<PoemDetailScreen> createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends State<PoemDetailScreen> {
  late bool _showNepali = widget.poem.language == 'ne';
  late int _likes = widget.poem.likes;
  bool _liked = false;

  final _comments = <PoemComment>[
    const PoemComment(authorName: 'Aasha Thapa', text: 'That last line stayed with me all evening.'),
  ];
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(PoemComment(authorName: 'You', text: text));
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final poem = widget.poem;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.bookmark_border, color: AppColors.ink),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_horiz, color: AppColors.ink),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.accentSoft,
                      child: Text(poem.authorName.characters.first,
                          style: AppFonts.ui(color: AppColors.accent)),
                    ),
                    const SizedBox(width: 10),
                    Text(poem.authorName, style: AppFonts.ui(weight: FontWeight.w600)),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Follow'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- नेपाली / English toggle ---
                // This only makes sense to show if you actually have both
                // versions of the poem stored. For now it toggles the font
                // treatment; wire it to a real translation field later.
                Row(
                  children: [
                    _LangPill(
                      label: 'नेपाली',
                      selected: _showNepali,
                      onTap: () => setState(() => _showNepali = true),
                    ),
                    const SizedBox(width: 8),
                    _LangPill(
                      label: 'English',
                      selected: !_showNepali,
                      onTap: () => setState(() => _showNepali = false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  poem.title,
                  style: AppFonts.forLanguage(poem.language,
                      size: 30, weight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Text(
                  poem.body,
                  style: AppFonts.forLanguage(poem.language, size: 18, height: 1.7),
                ),

                if (poem.hasAudio) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.accent,
                          child: Icon(Icons.play_arrow_rounded, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text('The poet reads this', style: AppFonts.ui()),
                        const Spacer(),
                        Text(poem.audioDuration ?? '',
                            style: AppFonts.ui(color: AppColors.inkMuted, size: 12)),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                Row(
                  children: [
                    _ReactionButton(
                      icon: _liked ? Icons.favorite : Icons.favorite_border,
                      label: '$_likes',
                      color: _liked ? AppColors.accent : AppColors.ink,
                      onTap: () => setState(() {
                        _liked = !_liked;
                        _likes += _liked ? 1 : -1;
                      }),
                    ),
                    const SizedBox(width: 16),
                    Text('Resonate', style: AppFonts.ui(color: AppColors.inkMuted)),
                    const SizedBox(width: 16),
                    _ReactionButton(
                      icon: Icons.chat_bubble_outline,
                      label: '${_comments.length}',
                      onTap: () {},
                    ),
                    const Spacer(),
                    const Icon(Icons.ios_share, color: AppColors.inkMuted),
                  ],
                ),
                const Divider(height: 32, color: AppColors.border),
                Text('Comments', style: AppFonts.ui(weight: FontWeight.w600)),
                const SizedBox(height: 12),
                ..._comments.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.accentSoft,
                            child: Text(c.authorName.characters.first,
                                style: AppFonts.ui(size: 11, color: AppColors.accent)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.authorName,
                                    style: AppFonts.ui(weight: FontWeight.w600, size: 13)),
                                const SizedBox(height: 2),
                                Text(c.text, style: AppFonts.english(size: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- comment input, pinned to the bottom of the screen ---
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: AppFonts.english(size: 14),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: AppFonts.ui(color: AppColors.inkMuted, size: 14),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                  IconButton(
                    onPressed: _submitComment,
                    icon: const Icon(Icons.send_rounded, color: AppColors.accent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangPill({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.ink : AppColors.border),
        ),
        child: Text(
          label,
          style: AppFonts.ui(color: selected ? Colors.white : AppColors.ink),
        ),
      ),
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = AppColors.ink,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppFonts.ui(color: color)),
        ],
      ),
    );
  }
}
