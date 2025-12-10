import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/favorite_button.dart';
import '../models/product_model.dart';

class ProductGridCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite; // Kept for backward compatibility, but not used
  final VoidCallback? onFavoriteTap;

  const ProductGridCard({
    super.key,
    required this.product,
    this.isFavorite = false, // Not used anymore, FavoriteButton handles it
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
                  height: 138.h,
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
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: FavoriteButton(
                    productId: product.id,
                    onTap: onFavoriteTap,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          color: AppColors.blackTextColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 3.h,
                          children: [
                            Text(
                              '${product.price} ${product.currency}',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product.oldPrice,
                              style: TextStyle(
                                color: AppColors.greyTextColor,
                                fontSize: 11.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '${product.discount}% Off',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(5, (index) {
                              return Icon(
                                index < product.averageRating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 12.sp,
                              );
                            }),
                            SizedBox(width: 3.w),
                            Flexible(
                              child: Text(
                                product.reviewsCount.toString(),
                                style: TextStyle(
                                  color: AppColors.greyTextColor,
                                  fontSize: 10.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
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
