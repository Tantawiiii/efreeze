import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constant/app_colors.dart';

class BrandShimmerLoading extends StatelessWidget {
  const BrandShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Shimmer.fromColors(
              baseColor: AppColors.textFieldBorderColor,
              highlightColor: AppColors.white,
              period: const Duration(milliseconds: 1200),
              child: Column(
                children: [
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 60.w,
                    height: 12.h,
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

