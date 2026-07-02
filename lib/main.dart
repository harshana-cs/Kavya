// lib/main.dart
//
// Entry point. Two things happen here that are worth understanding as a
// beginner:
//
// 1. `ProviderScope` — this MUST wrap the whole app for Riverpod
//    (poems_provider.dart) to work anywhere. It's the "container" that
//    actually holds provider state in memory.
//
// 2. `MainShell` — a small StatefulWidget that owns which bottom-nav tab
//    is selected and swaps between Feed / Explore / Profile using an
//    IndexedStack (keeps all three alive in memory so switching tabs
//    doesn't lose scroll position — try commenting this out and using a
//    plain conditional to see the difference).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/feed_screen.dart';
import 'screens/placeholder_screens.dart';
import 'screens/record_screen.dart';
import 'screens/write_screen.dart';
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
      home: const MainShell(),
    );
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
