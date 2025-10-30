import 'dart:io';

import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constant/app_colors.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) return;
    } else {

      await Permission.photos.request();
      await Permission.storage.request();
    }

    final XFile? file = await _picker.pickImage(source: source, imageQuality: 90);
    if (file == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 95,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );


    if (cropped == null) return;
    setState(() => _avatarFile = File(cropped.path));
  }

  void _showPickSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _PickOption(
                icon: Icons.photo_camera_outlined,
                label: AppTexts.camera,
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatar(ImageSource.camera);
                },
              ),
              _PickOption(
                icon: Icons.photo_library_outlined,
                label: AppTexts.gallery,
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatar(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTexts.createAcc), backgroundColor: Colors.transparent,),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),
              Center(
                child: GestureDetector(
                  onTap: _showPickSheet,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48.r,
                        backgroundColor: AppColors.textFieldBorderColor,
                        backgroundImage: _avatarFile == null ? null : FileImage(_avatarFile!),
                        child: _avatarFile == null
                            ? Icon(Icons.person, color: AppColors.greyTextColor, size: 40.sp)
                            : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit, color: Colors.white, size: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              AppTextField(
                controller: _nameController,
                hint: AppTexts.fullName,
                leadingIcon: Icons.person_outline,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _emailController,
                hint: AppTexts.email,
                keyboardType: TextInputType.emailAddress,
                leadingIcon: Icons.email_outlined,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _phoneController,
                hint: AppTexts.phoneNum,
                keyboardType: TextInputType.phone,
                leadingIcon: Icons.phone_outlined,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _passwordController,
                hint: AppTexts.password,
                obscure: true,
                obscurable: true,
                leadingIcon: Icons.lock_outline,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _confirmPasswordController,
                hint:  AppTexts.confirmPassword,
                obscure: true,
                obscurable: true,
                leadingIcon: Icons.lock_outline,
              ),
              SizedBox(height: 40.h),
              PrimaryButton(title: AppTexts.createAcc, onPressed: () {}),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickOption extends StatelessWidget {
  const _PickOption({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.overlayColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.blackTextColor, size: 28.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}


