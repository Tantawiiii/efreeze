import 'package:efreeze/core/constant/app_assets.dart';
import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../auth/models/user_model.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = di.sl<StorageService>();
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<UserModel?>(
      valueListenable: storageService.userNotifier,
      builder: (context, user, _) {
        final displayName = (user?.name.isNotEmpty ?? false)
            ? user!.name.split(' ').first
            : AppTexts.myAccount;

        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
          child: Row(
            children: [
              _ProfileAvatar(user: user),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.welcomeBack,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.lightGreyText,
                      ),
                    ),
                    Text(
                      displayName,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Image.asset(
                AppAssets.appLogoHeaderImg,
                height: 102.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final avatar = user?.avatar;
    final hasAvatar = avatar != null && avatar.isNotEmpty;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.userInfo),
      child: CircleAvatar(
        radius: 20.r,
        backgroundColor: AppColors.overlayColor,
        backgroundImage: hasAvatar ? NetworkImage(avatar) : null,
        child: !hasAvatar
            ? Icon(
                Icons.person_outline_rounded,
                color: AppColors.primaryColor,
                size: 20.sp,
              )
            : null,
      ),
    );
  }
}
