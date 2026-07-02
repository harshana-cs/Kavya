// lib/screens/record_screen.dart
//
// "Record · voice or video of the reading" from THE FLOW.
//
// NOTE ON SCOPE: this screen's *layout and interaction* (timer, takes
// list, voice/video toggle) is fully working. The actual microphone
// capture is stubbed with a `Timer` that just counts seconds, so you can
// see and test the UI immediately without dealing with permissions. The
// README's "Next steps" section shows exactly how to swap the stub for
// real recording using the `record` package.

import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Take {
  final int number;
  final Duration length;
  Take({required this.number, required this.length});
}

class RecordScreen extends StatefulWidget {
  final String poemTitle;
  const RecordScreen({super.key, required this.poemTitle});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool _isVideo = false;
  bool _isRecording = false;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  final List<Take> _takes = [];
  int? _selectedTakeIndex;

  void _startStopRecording() {
    if (_isRecording) {
      _timer?.cancel();
      setState(() {
        _isRecording = false;
        _takes.add(Take(number: _takes.length + 1, length: _elapsed));
        _selectedTakeIndex = _takes.length - 1;
        _elapsed = Duration.zero;
      });
    } else {
      setState(() {
        _isRecording = true;
        _elapsed = Duration.zero;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(1, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                  Text('${widget.poemTitle}  ·  reading',
                      style: AppFonts.ui(color: Colors.white70, size: 13)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // --- Voice / Video segmented toggle ---
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SegButton(
                      label: 'Voice',
                      selected: !_isVideo,
                      onTap: () => setState(() => _isVideo = false)),
                  _SegButton(
                      label: 'Video',
                      selected: _isVideo,
                      onTap: () => setState(() => _isVideo = true)),
                ],
              ),
            ),

            const Spacer(),

            Text(_fmt(_elapsed),
                style: AppFonts.ui(
                    color: Colors.white, size: 32, weight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(_isRecording ? 'RECORDING' : 'READY',
                style: AppFonts.ui(color: Colors.white38, size: 11)),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _takes.isEmpty ? null : () => setState(_takes.clear),
                  icon: Icon(Icons.delete_outline,
                      color: _takes.isEmpty ? Colors.white24 : Colors.white70),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: _startStopRecording,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 3),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius: _isRecording ? BorderRadius.circular(6) : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  onPressed: _takes.isEmpty ? null : () => Navigator.of(context).pop(),
                  icon: Icon(Icons.check,
                      color: _takes.isEmpty ? Colors.white24 : Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // --- Takes list ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF17130F),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TAKES', style: AppFonts.ui(color: Colors.white38, size: 11)),
                  const SizedBox(height: 12),
                  if (_takes.isEmpty)
                    Text('No takes yet — record one above.',
                        style: AppFonts.ui(color: Colors.white38, size: 13)),
                  ..._takes.asMap().entries.map((entry) {
                    final i = entry.key;
                    final take = entry.value;
                    final selected = _selectedTakeIndex == i;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () => setState(() => _selectedTakeIndex = i),
                        child: Row(
                          children: [
                            const Icon(Icons.play_circle_fill,
                                color: Colors.white70, size: 22),
                            const SizedBox(width: 10),
                            Text('Take ${take.number}',
                                style: AppFonts.ui(color: Colors.white, size: 14)),
                            const SizedBox(width: 8),
                            Text(_fmt(take.length),
                                style: AppFonts.ui(color: Colors.white38, size: 12)),
                            const Spacer(),
                            if (selected)
                              const Text('selected',
                                  style: TextStyle(color: Colors.white38, fontSize: 12))
                            else
                              const SizedBox.shrink(),
                            if (selected) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.check, color: AppColors.accent, size: 16),
                            ]
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SegButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppFonts.ui(
              color: selected ? Colors.black : Colors.white70,
              weight: FontWeight.w600),
        ),
      ),
    );
  }
}
