import 'package:efreeze/core/constant/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../auth/models/user_model.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = di.sl<StorageService>();
    return ValueListenableBuilder<UserModel?>(
      valueListenable: storageService.userNotifier,
      builder: (context, user, _) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.userInfo);
                },
                child: CircleAvatar(
                  radius: 24.r,
                  backgroundColor: AppColors.textFieldBorderColor,
                  backgroundImage:
                      (user?.avatar != null && user!.avatar!.isNotEmpty)
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: (user?.avatar == null || user!.avatar!.isEmpty)
                      ? Icon(
                          Icons.person,
                          color: AppColors.greyTextColor,
                          size: 20.sp,
                        )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
