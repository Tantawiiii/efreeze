import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/product_details_cubit.dart';
import '../models/product_model.dart';
import '../widgets/product_image_slider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<ProductDetailsCubit>()..getProductDetails(productId),
      child: BlocListener<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          if (state is AddToCartSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AddToCartFailure) {
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
          body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              if (state is ProductDetailsFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                      SizedBox(height: 16.h),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<ProductDetailsCubit>()
                              .getProductDetails(productId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Get product from current state or cached
              ProductModel? product;
              if (state is ProductDetailsSuccess) {
                product = state.response.data;
              } else if (state is AddToCartSuccess || 
                         state is AddToCartFailure || 
                         state is AddToCartLoading) {
                // Use cached product details when add-to-cart states are active
                final cubit = context.read<ProductDetailsCubit>();
                product = cubit.cachedProductDetails?.data;
              }

              if (product != null) {
                final currentProduct = product;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageSlider(
                        image: currentProduct.image,
                        linkVideo: currentProduct.linkVideo,
                        gallery: currentProduct.gallery,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              currentProduct.name,
                              style: TextStyle(
                                color: AppColors.blackTextColor,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 12.w,
                              runSpacing: 8.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  '${currentProduct.price} ${currentProduct.currency}',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currentProduct.oldPrice,
                                  style: TextStyle(
                                    color: AppColors.greyTextColor,
                                    fontSize: 16.sp,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    '${currentProduct.discount}% Off',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),

                            Row(
                              children: [
                                ...List.generate(5, (index) {
                                  return Icon(
                                    index < currentProduct.averageRating.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20.sp,
                                  );
                                }),
                                SizedBox(width: 8.w),
                                Text(
                                  '${currentProduct.averageRating.toStringAsFixed(1)} (${currentProduct.reviewsCount} reviews)',
                                  style: TextStyle(
                                    color: AppColors.greyTextColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            Text(
                              'Description',
                              style: TextStyle(
                                color: AppColors.blackTextColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              currentProduct.description,
                              style: TextStyle(
                                color: AppColors.greyTextColor,
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            // Product Details Section
                            if (currentProduct.type.isNotEmpty ||
                                currentProduct.color.isNotEmpty ||
                                currentProduct.quantity > 0) ...[
                              Text(
                                'Product Details',
                                style: TextStyle(
                                  color: AppColors.blackTextColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              if (currentProduct.type.isNotEmpty)
                                _buildDetailRow('Type', currentProduct.type),
                              if (currentProduct.color.isNotEmpty)
                                _buildDetailRow('Color', currentProduct.color),
                              if (currentProduct.quantity > 0)
                                _buildDetailRow(
                                  'Quantity Available',
                                  currentProduct.quantity.toString(),
                                ),
                              SizedBox(height: 24.h),
                            ],
                            BlocBuilder<ProductDetailsCubit,
                                ProductDetailsState>(
                              builder: (context, state) {
                                final isLoading = state is AddToCartLoading;
                                return PrimaryButton(
                                  title: isLoading
                                      ? 'Adding to Cart...'
                                      : 'Add to Cart',
                                  onPressed: isLoading
                                      ? () {}
                                      : () {
                                          context
                                              .read<ProductDetailsCubit>()
                                              .addToCart(productId: currentProduct.id);
                                        },
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  AppRoutes.addReview,
                                  arguments: {'productId': currentProduct.id},
                                );
                                // Refresh product details if review was added successfully
                                if (result == true) {
                                  context
                                      .read<ProductDetailsCubit>()
                                      .getProductDetails(currentProduct.id);
                                }
                              },
                              icon: Icon(
                                Icons.rate_review,
                                size: 18.sp,
                                color: AppColors.primaryColor,
                              ),
                              label: Text(
                                'Write a Review',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50.h),
                                side: BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AppColors.greyTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.blackTextColor,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

