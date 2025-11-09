import 'package:efreeze/core/constant/app_texts.dart';
import 'package:efreeze/core/di/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/login_cubit.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(LoginCubit cubit) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    cubit.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                content: Text(AppTexts.loginSuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),
                    Image.asset(
                      AppAssets.appLogoSplashWithoutBAckImg,
                      width: 120.w,
                      height: 140.w,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      AppTexts.welcomeBack,
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      AppTexts.loginToCont,
                      style: TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 38.h),
                    AppTextField(
                      controller: _emailController,
                      hint: AppTexts.email,
                      keyboardType: TextInputType.emailAddress,
                      leadingIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTexts.pleaseEnterEmail;
                        }
                        if (!value.contains('@')) {
                          return AppTexts.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),
                    AppTextField(
                      controller: _passwordController,
                      hint: AppTexts.password,
                      obscure: true,
                      obscurable: true,
                      leadingIcon: Icons.lock_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTexts.pleaseEnterPass;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        final isLoading = state is LoginLoading;
                        return PrimaryButton(
                          title: isLoading ? AppTexts.loginLoading : AppTexts.login,
                          onPressed: isLoading
                              ? () {}
                              : () => _handleLogin(context.read<LoginCubit>()),
                        );
                      },
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppTexts.dontHaveAcc,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.greyTextColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signup),
                          child:  Text(AppTexts.signUp, style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16.sp
                          ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
