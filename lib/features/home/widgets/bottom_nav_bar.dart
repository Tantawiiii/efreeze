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
    return CurvedNavigationBar(
      index: selectedIndex,
      onTap: onTap,
      backgroundColor: Colors.transparent,
      color: AppColors.primaryColor,
      buttonBackgroundColor: AppColors.primaryColor,
      height: 70.h,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        Icon(Icons.favorite_border, color: Colors.white, size: 24.r),
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
              icon: Icons.shopping_cart,
              count: itemCount,
            );
          },
        ),
        Icon(Icons.home, color: Colors.white, size: 24.r),
        Icon(Icons.search, color: Colors.white, size: 24.r),
        Icon(Icons.settings, color: Colors.white, size: 24.r),
      ],
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
            right: -6.w,
            top: -6.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

