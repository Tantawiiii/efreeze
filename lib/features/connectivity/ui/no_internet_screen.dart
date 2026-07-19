import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../shared/widgets/primary_button.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isRetrying = false;

  Future<void> _retry() async {
    if (_isRetrying) return;

    setState(() => _isRetrying = true);
    await context.read<ConnectivityCubit>().checkConnection(force: true);
    if (mounted) {
      setState(() => _isRetrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 112.w,
                height: 112.w,
                decoration: BoxDecoration(
                  color: AppColors.overlayColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 52.sp,
                  color: AppColors.primaryColor.withValues(alpha: 0.75),
                ),
              ),
              SizedBox(height: 28.h),
              Text(
                AppTexts.noInternetTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackTextColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppTexts.noInternetSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.45,
                  color: AppColors.greyTextColor,
                ),
              ),
              SizedBox(height: 32.h),
              PrimaryButton(
                title: AppTexts.retryConnection,
                isLoading: _isRetrying,
                onPressed: _isRetrying ? null : _retry,
                icon: Icons.refresh_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
