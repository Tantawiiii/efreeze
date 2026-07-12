import 'package:flutter/material.dart';

/// Marks screens that overlay content on top of a bottom navigation bar.
class AppShell extends InheritedWidget {
  const AppShell({
    super.key,
    required this.bottomOverlayHeight,
    required super.child,
  });

  final double bottomOverlayHeight;

  static double bottomOverlayOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<AppShell>()
            ?.bottomOverlayHeight ??
        0;
  }

  @override
  bool updateShouldNotify(AppShell oldWidget) =>
      bottomOverlayHeight != oldWidget.bottomOverlayHeight;
}
