// lib/screens/write_screen.dart
//
// "Write · Nepali or English, save a draft" from THE FLOW.
// This is a ConsumerStatefulWidget because Publish/Save Draft need to
// call methods on poemsProvider (see state/poems_provider.dart).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/poems_provider.dart';
import '../theme/app_theme.dart';
import 'record_screen.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> {
  String _language = 'ne'; // matches the mockup: नेपाली selected by default
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _draftSaved = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _saveDraft() {
    ref.read(poemsProvider.notifier).addDraft(
          title: _titleController.text,
          body: _bodyController.text,
          language: _language,
        );
    setState(() => _draftSaved = true);
  }

  void _publish() {
    // Save as a draft first (reuses the same logic), then flip it to
    // published. In a real app you'd likely combine these into one method
    // that takes a status argument — kept as two calls here so each step
    // is easy to follow.
    ref.read(poemsProvider.notifier).addDraft(
          title: _titleController.text,
          body: _bodyController.text,
          language: _language,
        );
    final newest = ref.read(poemsProvider).first;
    ref.read(poemsProvider.notifier).publish(newest.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: AppFonts.ui(color: AppColors.inkMuted)),
        ),
        leadingWidth: 90,
        title: _draftSaved
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: AppColors.accent),
                  const SizedBox(width: 6),
                  Text('Draft saved', style: AppFonts.ui(size: 13)),
                ],
              )
            : null,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _publish,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Publish'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      _LangToggle(
                        label: 'नेपाली',
                        selected: _language == 'ne',
                        onTap: () => setState(() => _language = 'ne'),
                      ),
                      const SizedBox(width: 8),
                      _LangToggle(
                        label: 'English',
                        selected: _language == 'en',
                        onTap: () => setState(() => _language = 'en'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _titleController,
                    style: AppFonts.forLanguage(_language,
                        size: 26, weight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: _language == 'ne' ? 'शीर्षक' : 'Title',
                      hintStyle: AppFonts.forLanguage(_language,
                          size: 26, weight: FontWeight.w600, color: AppColors.inkMuted),
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() => _draftSaved = false),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bodyController,
                    maxLines: null,
                    style: AppFonts.forLanguage(_language, size: 18, height: 1.7),
                    decoration: InputDecoration(
                      hintText: _language == 'ne'
                          ? 'तपाईंको कविता यहाँ लेख्नुहोस्...'
                          : 'Write your poem here...',
                      hintStyle:
                          AppFonts.forLanguage(_language, size: 18, color: AppColors.inkMuted),
                      border: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() => _draftSaved = false),
                  ),
                ],
              ),
            ),
          ),

          // --- bottom toolbar: Aa / paragraph / record reading ---
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Text('Aa', style: AppFonts.ui(weight: FontWeight.w600)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.format_align_left, color: AppColors.inkMuted),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RecordScreen(poemTitle: _titleController.text.isEmpty
                                  ? 'Untitled'
                                  : _titleController.text),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mic_none, color: AppColors.ink, size: 18),
                    label: Text('Record reading', style: AppFonts.ui()),
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

class _LangToggle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangToggle({required this.label, required this.selected, required this.onTap});

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
        child: Text(label,
            style: AppFonts.ui(color: selected ? Colors.white : AppColors.ink)),
      ),
    );
  }
}
