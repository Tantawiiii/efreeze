import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/contact_us_cubit.dart';

class ContactUsTab extends StatefulWidget {
  const ContactUsTab({super.key});

  @override
  State<ContactUsTab> createState() => _ContactUsTabState();
}

class _ContactUsTabState extends State<ContactUsTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit(ContactUsCubit cubit) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    cubit.sendContactMessage(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      message: _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsCubit, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.response.message ?? 'Message sent successfully!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _messageController.clear();
        } else if (state is ContactUsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Get in Touch',
                style: TextStyle(
                  color: AppColors.blackTextColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
                style: TextStyle(
                  color: AppColors.greyTextColor,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 32.h),
              // Name
              AppTextField(
                controller: _nameController,
                hint: 'Name',
                leadingIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              // Email
              AppTextField(
                controller: _emailController,
                hint: 'Email',
                leadingIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              // Phone
              AppTextField(
                controller: _phoneController,
                hint: 'Phone',
                leadingIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              // Message
              AppTextField(
                controller: _messageController,
                hint: 'Message',
                leadingIcon: Icons.message_outlined,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your message';
                  }
                  if (value.trim().length < 10) {
                    return 'Message must be at least 10 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.h),
              // Submit Button
              BlocBuilder<ContactUsCubit, ContactUsState>(
                builder: (context, state) {
                  final isLoading = state is ContactUsLoading;
                  return PrimaryButton(
                    title: isLoading ? 'Sending...' : 'Send Message',
                    onPressed: isLoading
                        ? null
                        : () => _handleSubmit(
                              context.read<ContactUsCubit>(),
                            ),
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

