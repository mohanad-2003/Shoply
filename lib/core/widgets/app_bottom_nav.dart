import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_extensions.dart';
import '../routing/route_names.dart';

/// Shared bottom navigation bar reused by the top-level tab pages
/// (Home / Wishlist / Cart / Profile). Each page is an independent top-level
/// route — there is no [ShellRoute]; the widget simply highlights the active
/// tab via [currentIndex] and navigates on selection.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    this.onDestinationSelected,
  });

  final int currentIndex;

  /// Optional override. When null, taps navigate to the matching top-level
  /// route (re-selecting the current tab is a no-op).
  final ValueChanged<int>? onDestinationSelected;

  void _defaultSelect(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.goNamed(RouteNames.nHome);
      case 1:
        context.goNamed(RouteNames.nWishlist);
      case 2:
        context.goNamed(RouteNames.nCart);
      case 3:
        context.goNamed(RouteNames.nProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected ??
          (index) => _defaultSelect(context, index),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.favorite_border_rounded),
          selectedIcon: const Icon(Icons.favorite_rounded),
          label: l10n.wishlist,
        ),
        NavigationDestination(
          icon: const Icon(Icons.shopping_bag_outlined),
          selectedIcon: const Icon(Icons.shopping_bag_rounded),
          label: l10n.cart,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          label: l10n.profile,
        ),
      ],
    );
  }
}
