import 'package:efreeze/core/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/di/inject.dart' as di;

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = di.sl<StorageService>();
    final user = storageService.getUser();

    return Padding(
      padding: EdgeInsets.only(right:  16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              AppAssets.appLogoHeaderImg,
              height: 100.h,
              fit: BoxFit.cover,
            ),
          ),
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.textFieldBorderColor,
            backgroundImage: user?.avatar != null
                ? NetworkImage(user!.avatar!)
                : null,
            child: user?.avatar == null
                ? Icon(
                    Icons.person,
                    color: AppColors.greyTextColor,
                    size: 20.sp,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
