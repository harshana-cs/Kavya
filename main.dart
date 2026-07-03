// lib/main.dart
//
// Entry point. Three things happen here that are worth understanding as a
// beginner:
//
// 1. `ProviderScope` — this MUST wrap the whole app for Riverpod
//    (poems_provider.dart, auth_provider.dart) to work anywhere. It's the
//    "container" that actually holds provider state in memory.
//
// 2. `AuthGate` — watches authProvider and decides what to show: a
//    loading spinner while we check for a saved login, the Login screen
//    if nobody's logged in, or the real app (MainShell) if they are.
//    This is the standard Flutter pattern for "logged in vs not."
//
// 3. `MainShell` — a small StatefulWidget that owns which bottom-nav tab
//    is selected and swaps between Feed / Explore / Profile using an
//    IndexedStack (keeps all three alive in memory so switching tabs
//    doesn't lose scroll position).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/feed_screen.dart';
import 'screens/login_screen.dart';
import 'screens/placeholder_screens.dart';
import 'screens/record_screen.dart';
import 'screens/write_screen.dart';
import 'state/auth_provider.dart';
import 'theme/app_theme.dart';
import 'widgets/kavita_bottom_nav.dart';

void main() {
  runApp(const ProviderScope(child: KavitaApp()));
}

class KavitaApp extends StatelessWidget {
  const KavitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kavita',
      debugShowCheckedModeBanner: false,
      theme: buildKavitaTheme(),
      home: const AuthGate(),
    );
  }
}

/// Decides which screen to show based on login state. Because it watches
/// authProvider, it automatically rebuilds the moment login/logout
/// happens anywhere in the app — no manual navigation needed on
/// successful login (see login_screen.dart's _submit method).
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    switch (auth.status) {
      case AuthStatus.checking:
        return const Scaffold(
          backgroundColor: AppColors.background,
          body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
        );
      case AuthStatus.loggedOut:
        return const LoginScreen();
      case AuthStatus.loggedIn:
        return const MainShell();
    }
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tabIndex = 0;

  static const _tabs = [
    FeedScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tabIndex, children: _tabs),
      bottomNavigationBar: KavitaBottomNav(
        selectedTab: _tabIndex,
        onTabSelected: (i) => setState(() => _tabIndex = i),
        onWrite: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const WriteScreen()));
        },
        onRecord: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const RecordScreen(poemTitle: 'New reading')),
          );
        },
      ),
    );
  }
}
