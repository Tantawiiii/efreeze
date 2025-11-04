import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';

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
        Icon(Icons.shopping_cart, color: Colors.white, size: 24.r),
        Icon(Icons.home, color: Colors.white, size: 24.r),
        Icon(Icons.search, color: Colors.white, size: 24.r),
        Icon(Icons.settings, color: Colors.white, size: 24.r),
      ],
    );
  }
}

