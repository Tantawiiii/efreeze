import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../shared/widgets/favorite_button.dart';
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

  bool get _hasDiscount =>
      product.discount.isNotEmpty &&
      product.discount != '0' &&
      product.discount != '0%';

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
        decoration: AppDecorations.card(radius: 14),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 110.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(
                    color: AppColors.overlayColor,
                    child: product.image != null
                        ? CachedNetworkImage(
                            imageUrl: product.image!,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_outlined,
                              color: AppColors.greyTextColor,
                              size: 28.sp,
                            ),
                          )
                        : Icon(
                            Icons.image_outlined,
                            color: AppColors.greyTextColor,
                            size: 28.sp,
                          ),
                  ),
                  if (_hasDiscount)
                    PositionedDirectional(
                      top: 6.h,
                      start: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.discountColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '${product.discount}%',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  PositionedDirectional(
                    top: 4.h,
                    end: 4.w,
                    child: FavoriteButton(
                      productId: product.id,
                      onTap: onFavoriteTap,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: AppColors.blackTextColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${product.price} ${product.currency}',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.oldPrice.isNotEmpty && _hasDiscount) ...[
                    SizedBox(height: 1.h),
                    Text(
                      '${product.oldPrice} ${product.currency}',
                      style: TextStyle(
                        color: AppColors.lightGreyText,
                        fontSize: 9.5.sp,
                        decoration: TextDecoration.lineThrough,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (product.reviewsCount > 0 || product.averageRating > 0) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber.shade600,
                          size: 11.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          product.averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (product.reviewsCount > 0) ...[
                          SizedBox(width: 2.w),
                          Text(
                            '(${product.reviewsCount})',
                            style: TextStyle(
                              color: AppColors.lightGreyText,
                              fontSize: 9.5.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
