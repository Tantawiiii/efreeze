import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/product_details_cubit.dart';
import '../models/product_model.dart';
import '../widgets/product_image_slider.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../home/services/products_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              di.sl<ProductDetailsCubit>()..getProductDetails(productId),
        ),
        BlocProvider(
          create: (context) {
            try {
              final existingCubit = context.read<CartCubit>();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                existingCubit.getCart();
              });
              return existingCubit;
            } catch (e) {
              final newCubit = di.sl<CartCubit>();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                newCubit.getCart();
              });
              return newCubit;
            }
          },
        ),
      ],
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
          // Refresh cart after adding to cart
          if (state is AddToCartSuccess) {
            context.read<CartCubit>().getCart();
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
                          context.read<ProductDetailsCubit>().getProductDetails(
                            productId,
                          );
                        },
                        child: Text(AppTexts.retry),
                      ),
                    ],
                  ),
                );
              }

              ProductModel? product;
              if (state is ProductDetailsSuccess) {
                product = state.response.data;
              } else if (state is AddToCartSuccess ||
                  state is AddToCartFailure ||
                  state is AddToCartLoading) {
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
                                    '${currentProduct.discount}% ${AppTexts.off}',
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
                                  '${currentProduct.averageRating.toStringAsFixed(1)} (${currentProduct.reviewsCount} ${AppTexts.reviewsCountLabel})',
                                  style: TextStyle(
                                    color: AppColors.greyTextColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.h),

                            Text(
                              AppTexts.description,
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
                            if (currentProduct.type.isNotEmpty ||
                                currentProduct.color.isNotEmpty ||
                                currentProduct.quantity > 0) ...[
                              Text(
                                AppTexts.productDetails,
                                style: TextStyle(
                                  color: AppColors.blackTextColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              if (currentProduct.type.isNotEmpty)
                                _buildDetailRow(
                                  AppTexts.type,
                                  currentProduct.type,
                                ),
                              if (currentProduct.color.isNotEmpty)
                                _buildDetailRow(
                                  AppTexts.color,
                                  currentProduct.color,
                                ),
                              if (currentProduct.quantity > 0)
                                _buildDetailRow(
                                  AppTexts.quantityAvailable,
                                  currentProduct.quantity.toString(),
                                ),
                              SizedBox(height: 24.h),
                            ],
                            _buildConfidenceSection(currentProduct),
                            SizedBox(height: 24.h),
                            BlocBuilder<CartCubit, CartState>(
                              builder: (context, cartState) {
                                int cartQuantity = 0;
                                if (cartState is CartSuccess) {
                                  try {
                                    final cartItem = cartState.response.data
                                        .firstWhere(
                                          (item) =>
                                              item.cardId == currentProduct.id,
                                        );
                                    cartQuantity = cartItem.quantity;
                                  } catch (e) {
                                    cartQuantity = 0;
                                  }
                                }

                                if (cartQuantity > 0) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppTexts.inCart,
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            _buildQuantityButton(
                                              context: context,
                                              icon: Icons.remove,
                                              onTap: () {
                                                _updateQuantity(
                                                  context,
                                                  currentProduct.id,
                                                  'minus',
                                                );
                                              },
                                            ),
                                            SizedBox(width: 16.w),
                                            Text(
                                              cartQuantity.toString(),
                                              style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            _buildQuantityButton(
                                              context: context,
                                              icon: Icons.add,
                                              onTap: () {
                                                _updateQuantity(
                                                  context,
                                                  currentProduct.id,
                                                  'plus',
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return BlocBuilder<
                                  ProductDetailsCubit,
                                  ProductDetailsState
                                >(
                                  builder: (context, state) {
                                    final isLoading = state is AddToCartLoading;
                                    return PrimaryButton(
                                      title: isLoading
                                          ? AppTexts.addingToCart
                                          : AppTexts.addToCart,
                                      onPressed: isLoading
                                          ? () {}
                                          : () {
                                              context
                                                  .read<ProductDetailsCubit>()
                                                  .addToCart(
                                                    productId:
                                                        currentProduct.id,
                                                  );
                                            },
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 16.h),
                            if (currentProduct.reviews.isNotEmpty) ...[
                              Text(
                                AppTexts.reviewsTitle,
                                style: TextStyle(
                                  color: AppColors.blackTextColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: currentProduct.reviews.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 6.h),
                                itemBuilder: (context, index) {
                                  final review = currentProduct.reviews[index];
                                  return Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: AppColors.overlayColor,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                review.userName.isNotEmpty
                                                    ? review.userName
                                                    : AppTexts.anonymous,
                                                style: TextStyle(
                                                  color:
                                                      AppColors.blackTextColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Row(
                                              children: List.generate(5, (
                                                star,
                                              ) {
                                                return Icon(
                                                  star < review.rating.floor()
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16.sp,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        if (review.comment.isNotEmpty) ...[
                                          SizedBox(height: 8.h),
                                          Text(
                                            review.comment,
                                            style: TextStyle(
                                              color: AppColors.greyTextColor,
                                              fontSize: 14.sp,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                        if (review.createdAt.isNotEmpty) ...[
                                          SizedBox(height: 8.h),
                                          Text(
                                            review.createdAt,
                                            style: TextStyle(
                                              color: AppColors.greyTextColor,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 24.h),
                            ],
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
                                AppTexts.writeAReview,
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

  Widget _buildConfidenceSection(ProductModel product) {
    final items = <String>[
      AppTexts.secureTransaction,
      AppTexts.safeDelivery,
      AppTexts.returnIn15Days,
    ];

    if (product.freeDelivery) {
      items.add(AppTexts.freeDelivery);
    }
    if (product.oneYearWarranty) {
      items.add(AppTexts.oneYearWarranty);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTexts.shopWithConfidence,
          style: TextStyle(
            color: AppColors.blackTextColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: items.map(_buildConfidenceChip).toList(),
        ),
      ],
    );
  }

  Widget _buildConfidenceChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.primaryColor,
            size: 18.sp,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  void _updateQuantity(
    BuildContext context,
    int productId,
    String method,
  ) async {
    final productsService = di.sl<ProductsService>();
    try {
      await productsService.addToCart(productId: productId, method: method);
      if (context.mounted) {
        context.read<CartCubit>().getCart();
        context.read<ProductDetailsCubit>().getProductDetails(productId);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppTexts.failedToUpdateCart}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
