import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.textFieldFillColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: AppColors.lightGreyText,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  AppTexts.searchProductsHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightGreyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
