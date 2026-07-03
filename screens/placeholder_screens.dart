// lib/screens/placeholder_screens.dart
//
// Two very small screens so the bottom nav has somewhere to go for
// "Explore" and "You" (profile). Deliberately minimal — build these out
// once the core flow (feed -> detail -> write -> record -> drafts) feels
// solid. Keeping them here as one file to avoid clutter for now.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_provider.dart';
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

// ConsumerWidget (not StatelessWidget) because this screen needs to read
// authProvider — both to show the current username and to call
// ref.read(authProvider.notifier).logout() when the button is tapped.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(auth.username ?? 'Your profile',
                style: AppFonts.english(size: 20, weight: FontWeight.w600)),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => const MyPoemsScreen()));
              },
              child: const Text('My poems (drafts & published)'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              child: Text('Log out', style: AppFonts.ui(color: Colors.red.shade400)),
            ),
          ],
        ),
      ),
    );
  }
}
