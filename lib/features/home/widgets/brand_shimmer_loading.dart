import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/theme/app_decorations.dart';

class BrandShimmerLoading extends StatelessWidget {
  const BrandShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 5,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.textFieldBorderColor,
            highlightColor: AppColors.white,
            period: const Duration(milliseconds: 1200),
            child: SizedBox(
              width: 76.w,
              child: Column(
                children: [
                  Container(
                    width: 76.w,
                    height: 76.w,
                    decoration: AppDecorations.card(
                      radius: 16,
                      elevated: false,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 52.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
