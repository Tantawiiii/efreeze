import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.obscurable = false,
    this.keyboardType,
    this.leadingIcon,
    this.iconColor,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool obscurable;
  final TextInputType? keyboardType;
  final IconData? leadingIcon;
  final Color? iconColor;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        prefixIcon: widget.leadingIcon == null
            ? null
            : Icon(
                widget.leadingIcon,
                color: widget.iconColor ?? AppColors.greyTextColor,
                size: 22.sp,
              ),
        suffixIcon: widget.obscurable
            ? IconButton(
                onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.greyTextColor,
                  size: 22.sp,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.textFieldBorderColor),
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.4),
          borderRadius: BorderRadius.circular(10.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.errorBorderColor),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
