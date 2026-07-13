import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/app_colors.dart';
import '../../core/ui/app_shell.dart';

abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    bool isSuccess = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = isError
        ? AppColors.errorColor
        : isSuccess
            ? AppColors.successColor
            : AppColors.primaryColor;

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final shellInset = AppShell.bottomOverlayOf(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : isSuccess
                        ? Icons.check_circle_outline_rounded
                        : Icons.info_outline_rounded,
                color: AppColors.white,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: color,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(
            16.w,
            12.h,
            16.w,
            bottomInset + shellInset + 12.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, isSuccess: true);

  static void error(BuildContext context, String message) =>
      show(context, message: message, isError: true);
}
