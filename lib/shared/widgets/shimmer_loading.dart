import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constant/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.textFieldBorderColor,
      highlightColor: highlightColor ?? AppColors.white,
      period: period ?? const Duration(milliseconds: 1200),
      child: child,
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.textFieldBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(
            child: Container(
              width: double.infinity,
              height: 136.h,
              decoration: BoxDecoration(
                color: AppColors.textFieldBorderColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  child: Container(
                    width: double.infinity,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ShimmerLoading(
                  child: Container(
                    width: 100.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ShimmerLoading(
                  child: Container(
                    width: 80.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridCardShimmer extends StatelessWidget {
  const ProductGridCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.textFieldBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(
            child: Container(
              width: double.infinity,
              height: 138.h,
              decoration: BoxDecoration(
                color: AppColors.textFieldBorderColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoading(
                  child: Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                ShimmerLoading(
                  child: Container(
                    width: double.infinity,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ShimmerLoading(
                  child: Container(
                    width: 100.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ShimmerLoading(
                  child: Container(
                    width: 60.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListItemShimmer extends StatelessWidget {
  final double? height;
  final EdgeInsets? padding;

  const ListItemShimmer({
    super.key,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      height: height,
      child: Row(
        children: [
          ShimmerLoading(
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.textFieldBorderColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShimmerLoading(
                  child: Container(
                    width: double.infinity,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                ShimmerLoading(
                  child: Container(
                    width: 150.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

