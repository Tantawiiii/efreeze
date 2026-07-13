import 'package:efreeze/core/constant/app_texts.dart';
import 'package:efreeze/core/di/inject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleLogin(LoginCubit cubit) {
    if (!_formKey.currentState!.validate()) return;
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
            AppSnackbar.success(context, AppTexts.loginSuccess);
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is LoginFailure) {
            AppSnackbar.error(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 12.h),
                        Image.asset(
                          AppAssets.appLogoHeaderImg,
                          height: 160.h,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: 8.h),
                        Text(
                          AppTexts.welcomeBack,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppTexts.loginToCont,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 36.h),
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
                        SizedBox(height: 16.h),
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
                        SizedBox(height: 28.h),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            final isLoading = state is LoginLoading;
                            return PrimaryButton(
                              title: AppTexts.login,
                              isLoading: isLoading,
                              icon: Icons.login_rounded,
                              onPressed: isLoading
                                  ? null
                                  : () => _handleLogin(
                                      context.read<LoginCubit>(),
                                    ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppTexts.dontHaveAcc,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.signup),
                              child: Text(
                                AppTexts.signUp,
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
        ),
      ),
    );
  }
}
