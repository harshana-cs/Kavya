// lib/screens/placeholder_screens.dart
//
// Two very small screens so the bottom nav has somewhere to go for
// "Explore" and "You" (profile). Deliberately minimal — build these out
// once the core flow (feed -> detail -> write -> record -> drafts) feels
// solid. Keeping them here as one file to avoid clutter for now.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'my_poems_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text('Explore — coming soon', style: AppFonts.ui(color: AppColors.inkMuted)),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your profile — coming soon', style: AppFonts.ui(color: AppColors.inkMuted)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const MyPoemsScreen()));
              },
              child: const Text('My poems (drafts & published)'),
            ),
          ],
        ),
      ),
    );
  }
}
