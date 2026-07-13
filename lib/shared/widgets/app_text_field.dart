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
    this.validator,
    this.maxLines,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool obscurable;
  final TextInputType? keyboardType;
  final IconData? leadingIcon;
  final Color? iconColor;
  final String? Function(String?)? validator;
  final int? maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: _obscureText ? 1 : widget.maxLines,
          style: TextStyle(
            color: AppColors.blackTextColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: AppColors.textFieldFillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            prefixIcon: widget.leadingIcon == null
                ? null
                : Icon(
                    widget.leadingIcon,
                    color: _isFocused
                        ? AppColors.primaryColor
                        : widget.iconColor ?? AppColors.greyTextColor,
                    size: 22.sp,
                  ),
            suffixIcon: widget.obscurable
                ? IconButton(
                    onPressed: () =>
                        setState(() => _obscureText = !_obscureText),
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
              borderRadius: BorderRadius.circular(14.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.errorBorderColor),
              borderRadius: BorderRadius.circular(14.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.errorBorderColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        ),
      ),
    );
  }
}
