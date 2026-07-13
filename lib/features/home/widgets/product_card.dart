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

  EdgeInsets get _contentPadding => EdgeInsets.fromLTRB(6.w, 5.h, 6.w, 6.h);

  double get _sectionGap => 3.h;

  double get _actionHeight => 24.h;

  double get _titleSize => 10.5.sp;

  double get _priceSize => 11.5.sp;

  @override
  Widget build(BuildContext context) {
    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        width: inGrid ? double.infinity : 152.w,
        height: double.infinity,
        margin: inGrid
            ? EdgeInsets.zero
            : EdgeInsetsDirectional.only(end: 12.w),
        decoration: AppDecorations.card(radius: 14),
        clipBehavior: Clip.antiAlias,
        child: _buildFlexLayout(),
      ),
    );

    if (inGrid) {
      return card;
    }

    return Align(alignment: Alignment.topCenter, child: card);
  }

  Widget _buildFlexLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _buildImageSection()),
        Padding(
          padding: _contentPadding,
          child: _buildDetailsSection(),
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.blackTextColor,
            fontSize: _titleSize,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: _sectionGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                currentPrice,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: _priceSize,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            _buildCompactRating(),
          ],
        ),
        if (onAddToCart != null || (cartQuantity != null && cartQuantity! > 0)) ...[
          SizedBox(height: _sectionGap),
          _buildCartAction(),
        ],
      ],
    );
  }

  Widget _buildCompactRating() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.overlayColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.amber.shade600,
            size: 10.sp,
          ),
          SizedBox(width: 2.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (reviewCount > 0) ...[
            SizedBox(width: 2.w),
            Text(
              '($reviewCount)',
              style: TextStyle(
                color: AppColors.lightGreyText,
                fontSize: 8.5.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageSection({double? height}) {
    final image = Stack(
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
    );

    if (height != null) {
      return SizedBox(height: height, child: image);
    }

    return image;
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
          height: _actionHeight,
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
                size: 13.sp,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  AppTexts.addToCart,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
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
      height: _actionHeight,
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
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              cartQuantity.toString(),
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 11.sp,
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
    final size = 22.w;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(7.r),
        ),
        child: Icon(
          icon,
          size: 13.sp,
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
