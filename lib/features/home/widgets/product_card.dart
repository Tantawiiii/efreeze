import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../shared/widgets/favorite_button.dart';

class ProductCard extends StatelessWidget {
  final int? productId;
  final String title;
  final String description;
  final String currentPrice;
  final String originalPrice;
  final String discount;
  final double rating;
  final int reviewCount;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final int? cartQuantity;
  final VoidCallback? onAddToCart;
  final VoidCallback? onRemoveFromCart;
  final VoidCallback? onIncreaseQuantity;
  final bool inGrid;

  const ProductCard({
    super.key,
    this.productId,
    required this.title,
    required this.description,
    required this.currentPrice,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    this.imageUrl,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.cartQuantity,
    this.onAddToCart,
    this.onRemoveFromCart,
    this.onIncreaseQuantity,
    this.inGrid = false,
  });

  bool get _hasDiscount =>
      discount.isNotEmpty && discount != '0%' && discount != '0';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: inGrid ? double.infinity : 152.w,
          margin: inGrid
              ? EdgeInsets.zero
              : EdgeInsetsDirectional.only(end: 12.w),
          decoration: AppDecorations.card(radius: 14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageSection(),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.blackTextColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  _buildPriceBlock(),
                  if (reviewCount > 0 || rating > 0) ...[
                    SizedBox(height: 4.h),
                    _buildRatingChip(),
                  ],
                  if (onAddToCart != null ||
                      (cartQuantity != null && cartQuantity! > 0)) ...[
                    SizedBox(height: 6.h),
                    _buildCartAction(),
                  ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      height: 96.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: AppColors.overlayColor,
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => Center(
                      child: SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => _buildPlaceholder(),
                  )
                : _buildPlaceholder(),
          ),
          if (_hasDiscount)
            PositionedDirectional(
              top: 6.h,
              start: 6.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.discountColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  discount.contains('%') ? discount : '$discount%',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          if (productId != null)
            PositionedDirectional(
              top: 4.h,
              end: 4.w,
              child: FavoriteButton(
                productId: productId!,
                onTap: onFavoriteTap,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          currentPrice,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (originalPrice.isNotEmpty &&
            originalPrice != currentPrice &&
            _hasDiscount) ...[
          SizedBox(height: 1.h),
          Text(
            originalPrice,
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
      ],
    );
  }

  Widget _buildRatingChip() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 11.sp),
        SizedBox(width: 2.w),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: AppColors.greyTextColor,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (reviewCount > 0) ...[
          SizedBox(width: 2.w),
          Text(
            '($reviewCount)',
            style: TextStyle(
              color: AppColors.lightGreyText,
              fontSize: 9.5.sp,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCartAction() {
    if (cartQuantity != null && cartQuantity! > 0) {
      return _buildQuantityControl();
    }
    if (onAddToCart == null) {
      return const SizedBox.shrink();
    }
    return _buildAddButton();
  }

  Widget _buildAddButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAddToCart,
        borderRadius: BorderRadius.circular(8.r),
        child: Ink(
          width: double.infinity,
          height: 28.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_shopping_cart_outlined,
                size: 14.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                AppTexts.addToCart,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      width: double.infinity,
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _qtyButton(Icons.remove_rounded, onRemoveFromCart, filled: false),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              cartQuantity.toString(),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _qtyButton(
            Icons.add_rounded,
            onIncreaseQuantity ?? onAddToCart,
            filled: true,
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback? onTap, {required bool filled}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Icon(
          icon,
          size: 14.sp,
          color: filled ? AppColors.white : AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        color: AppColors.greyTextColor.withValues(alpha: 0.5),
        size: 28.sp,
      ),
    );
  }
}
