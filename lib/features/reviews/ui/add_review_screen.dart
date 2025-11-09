import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/di/inject.dart' as di;
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/review_cubit.dart';

class AddReviewScreen extends StatefulWidget {
  final int productId;

  const AddReviewScreen({
    super.key,
    required this.productId,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _selectedRating = 0;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedRating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppTexts.pleaseSelectRating),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<ReviewCubit>().addReview(
            productId: widget.productId,
            rating: _selectedRating,
            comment: _commentController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ReviewCubit>(),
      child: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Return true to indicate success
          } else if (state is ReviewFailure) {
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
          appBar: AppBar(
            title: Text(AppTexts.addReview),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.rateThisProduct,
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Rating Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final rating = index + 1;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedRating = rating;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Icon(
                              rating <= _selectedRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: rating <= _selectedRating
                                  ? Colors.amber
                                  : AppColors.greyTextColor,
                              size: 48.sp,
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      AppTexts.writeYourReview,
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _commentController,
                      hint: AppTexts.shareYourExperience,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppTexts.pleaseWriteReview;
                        }
                        if (value.trim().length < 10) {
                          return AppTexts.reviewMinCharacters;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),
                    BlocBuilder<ReviewCubit, ReviewState>(
                      builder: (context, state) {
                        final isLoading = state is ReviewLoading;
                        return PrimaryButton(
                          title: isLoading
                              ? AppTexts.submitting
                              : AppTexts.submitReview,
                          onPressed: isLoading
                              ? null
                              : () => _submitReview(context),
                        );
                      },
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

