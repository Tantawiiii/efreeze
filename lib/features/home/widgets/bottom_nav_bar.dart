import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../cart/cubit/cart_cubit.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: CurvedNavigationBar(
        index: selectedIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryLight,
        height: 64.h.clamp(56.0, 75.0),
        animationDuration: const Duration(milliseconds: 350),
        animationCurve: Curves.easeOutCubic,
        items: [
          Icon(Icons.favorite_border_rounded, color: Colors.white, size: 24.r),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartSuccess) {
                itemCount = state.response.data.fold<int>(
                  0,
                  (total, item) => total + item.quantity,
                );
              }
              return _NavItemWithBadge(
                icon: Icons.shopping_cart_rounded,
                count: itemCount,
              );
            },
          ),
          Icon(Icons.home_rounded, color: Colors.white, size: 26.r),
          Icon(Icons.search_rounded, color: Colors.white, size: 24.r),
          Icon(Icons.settings_rounded, color: Colors.white, size: 24.r),
        ],
      ),
    );
  }
}

class _NavItemWithBadge extends StatelessWidget {
  final IconData icon;
  final int count;

  const _NavItemWithBadge({
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final showBadge = count > 0;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: Colors.white, size: 24.r),
        if (showBadge)
          Positioned(
            right: -8.w,
            top: -8.h,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              constraints: BoxConstraints(minWidth: 18.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffEF4444), Color(0xffDC2626)],
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
