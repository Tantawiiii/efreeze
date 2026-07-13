import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../cubit/products_cubit.dart';
import '../models/product_model.dart';
import '../../../shared/widgets/section_header.dart';
import 'product_model_card.dart';

class ProductsSection extends StatefulWidget {
  final String title;
  final bool showSeeAll;
  final bool isBestProducts;

  const ProductsSection({
    super.key,
    required this.title,
    this.showSeeAll = true,
    this.isBestProducts = false,
  });

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load data only if not already loaded (will be skipped if cached)
      if (widget.isBestProducts) {
        context.read<ProductsCubit>().getBestProducts();
      } else {
        context.read<ProductsCubit>().getAllProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        List<ProductModel> products = [];
        bool isLoading = false;
        String? errorMessage;
        if (state is ProductsLoading) {
          isLoading = true;
        } else if (state is ProductsSuccess) {
          products = state.response.data;
        } else if (state is ProductsFailure) {
          errorMessage = state.message;
        }
        final displayProducts = products.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: widget.title,
              actionLabel: widget.showSeeAll && !isLoading ? AppTexts.seeAll : null,
              onActionTap: widget.showSeeAll && !isLoading
                  ? () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.allProducts,
                        arguments: {
                          'title': widget.title,
                          'isBestProducts': widget.isBestProducts,
                        },
                      );
                    }
                  : null,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 198.h,
              child: isLoading
                  ? _buildLoadingShimmer()
                  : errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )
                  : displayProducts.isEmpty
                  ? Center(
                      child: Text(
                        AppTexts.noAvailableProducts,
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsetsDirectional.only(
                        start: 20.w,
                        end: 8.w,
                      ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return ProductModelCard(product: product);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.only(start: 20.w, end: 8.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index == 2 ? 0 : 16.w),
          child: Shimmer.fromColors(
            baseColor: AppColors.textFieldBorderColor,
            highlightColor: AppColors.white,
            period: const Duration(milliseconds: 1200),
            child: Container(
              width: 152.w,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.overlayColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.textFieldBorderColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14.r),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120.w,
                          height: 11.h,
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBorderColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: 70.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBorderColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          width: double.infinity,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBorderColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
