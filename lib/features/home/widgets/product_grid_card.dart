import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../models/product_model.dart';

class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const ProductGridCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.productDetails,
          arguments: {'productId': product.id},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: AppColors.overlayColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                    ),
                  ),
                  child: product.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product.image!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_outlined,
                              color: AppColors.greyTextColor,
                              size: 40.sp,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.image_outlined,
                          color: AppColors.greyTextColor,
                          size: 40.sp,
                        ),
                ),
                if (onFavoriteTap != null)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : AppColors.greyTextColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            color: AppColors.blackTextColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          product.shortDescription,
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 11.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 4.h,
                          children: [
                            Text(
                              '${product.price} ${product.currency}',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.oldPrice,
                              style: TextStyle(
                                color: AppColors.greyTextColor,
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${product.discount}% Off',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < product.averageRating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 14.sp,
                              );
                            }),
                            SizedBox(width: 4.w),
                            Text(
                              product.reviewsCount.toString(),
                              style: TextStyle(
                                color: AppColors.greyTextColor,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
