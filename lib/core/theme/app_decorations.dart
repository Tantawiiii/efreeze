import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

abstract final class AppDecorations {
  static BoxDecoration card({
    Color? color,
    double radius = 16,
    bool elevated = true,
    Border? border,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.surfaceColor,
      borderRadius: BorderRadius.circular(radius.r),
      border: border ??
          Border.all(
            color: AppColors.textFieldBorderColor.withValues(alpha: 0.6),
            width: 0.5,
          ),
      boxShadow: elevated
          ? [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration bottomSheet() {
    return BoxDecoration(
      color: AppColors.surfaceColor,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  static BoxDecoration primaryGradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primaryColor, AppColors.primaryLight],
      ),
    );
  }
}
