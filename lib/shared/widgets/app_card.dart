import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_decorations.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.radius = 16,
    this.elevated = true,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final bool elevated;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: margin,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: AppDecorations.card(
        color: color,
        radius: radius,
        elevated: elevated,
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.r),
        splashColor: Colors.black.withValues(alpha: 0.04),
        highlightColor: Colors.black.withValues(alpha: 0.02),
        child: card,
      ),
    );
  }
}
