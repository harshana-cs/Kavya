// lib/widgets/kavita_bottom_nav.dart
//
// The mockup's bottom bar has 5 icons: Feed, Explore, a center "+" (write),
// Record, You. The +  and Record icons *push* a new screen on top of the
// stack rather than switching tabs — so this widget takes two kinds of
// callbacks: `onTabSelected` for the three real tabs, and `onWrite` /
// `onRecord` for the two push actions.

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KavitaBottomNav extends StatelessWidget {
  final int selectedTab; // 0 = Feed, 1 = Explore, 2 = You
  final ValueChanged<int> onTabSelected;
  final VoidCallback onWrite;
  final VoidCallback onRecord;

  const KavitaBottomNav({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onWrite,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavIcon(
                icon: Icons.menu,
                selected: selectedTab == 0,
                onTap: () => onTabSelected(0),
              ),
              _NavIcon(
                icon: Icons.search,
                selected: selectedTab == 1,
                onTap: () => onTabSelected(1),
              ),
              GestureDetector(
                onTap: onWrite,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
              _NavIcon(icon: Icons.mic_none, selected: false, onTap: onRecord),
              _NavIcon(
                icon: Icons.person_outline,
                selected: selectedTab == 2,
                onTap: () => onTabSelected(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: selected ? AppColors.accent : AppColors.inkMuted),
    );
  }
}
