import 'package:cached_network_image/cached_network_image.dart';
import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/localization/language_cubit.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../shared/widgets/animated_list_view.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/primary_button.dart';
import '../cubit/cart_cubit.dart';
import '../models/cart_item_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.watch<LanguageCubit>();

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartInitial) {
          context.read<CartCubit>().getCart();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        appBar: AppBar(
          title: Text(AppTexts.cart),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartInitial || state is CartLoading) {
              return ListView.separated(
                padding: EdgeInsets.all(20.w),
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (_, __) => const _CartItemShimmer(),
              );
            }

            if (state is CartFailure) {
              return EmptyState(
                icon: Icons.error_outline_rounded,
                title: state.message,
                actionLabel: AppTexts.retry,
                onAction: () => context.read<CartCubit>().getCart(),
              );
            }

            if (state is CartSuccess) {
              final cartItems = state.response.data;

              if (cartItems.isEmpty) {
                return EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: AppTexts.cartEmpty,
                  subtitle: AppTexts.addItemsToCart,
                );
              }

              final total = _calculateTotal(cartItems);

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: () => context.read<CartCubit>().getCart(),
                      child: AnimatedListView.builder(
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: cartItems.length,
                        separator: SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          return _CartItemCard(
                            cartItem: cartItems[index],
                            onMinus: () => _updateQuantity(
                              cartItems[index],
                              'minus',
                            ),
                            onPlus: () => _updateQuantity(
                              cartItems[index],
                              'plus',
                            ),
                            onDelete: () => _updateQuantity(
                              cartItems[index],
                              'delete',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _CheckoutFooter(
                    total: total,
                    onCheckout: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.checkout,
                        arguments: cartItems,
                      );
                    },
                  ),
                  SizedBox(height: 80.h),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _updateQuantity(CartItemModel cartItem, String method) async {
    final error = await context.read<CartCubit>().updateCartItem(
      cardId: cartItem.cardId,
      color: cartItem.requestColor,
      method: method,
    );

    if (!mounted) return;

    if (error != null) {
      AppSnackbar.error(context, error);
    }
  }

  String _calculateTotal(List<CartItemModel> cartItems) {
    var total = 0.0;
    var currency = AppTexts.eGP;

    for (final item in cartItems) {
      final price = double.tryParse(item.card.price) ?? 0.0;
      total += price * item.quantity;
      currency = item.card.currency;
    }

    return '${total.toStringAsFixed(2)} $currency';
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.cartItem,
    required this.onMinus,
    required this.onPlus,
    required this.onDelete,
  });

  final CartItemModel cartItem;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final product = cartItem.card;
    final imageUrl = product.displayImage;
    final unitPrice = double.tryParse(product.price) ?? 0.0;
    final lineTotal = unitPrice * cartItem.quantity;
    final colorLabel = cartItem.requestColor;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: {'productId': product.id},
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: AppDecorations.card(radius: 16),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 76.w,
                      height: 76.w,
                      decoration: BoxDecoration(
                        color: AppColors.overlayColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.image_outlined,
                                  color: AppColors.greyTextColor,
                                  size: 28.sp,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.image_outlined,
                              color: AppColors.greyTextColor,
                              size: 28.sp,
                            ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (colorLabel.isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            _ColorChip(label: colorLabel),
                          ],
                          SizedBox(height: 8.h),
                          Text(
                            '${product.price} ${product.currency}',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.lightGreyText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 32.w,
                        minHeight: 32.w,
                      ),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.lightGreyText,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      '${lineTotal.toStringAsFixed(2)} ${product.currency}',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    _QuantityStepper(
                      quantity: cartItem.quantity,
                      onMinus: onMinus,
                      onPlus: onPlus,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        '${AppTexts.color}: $label',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColors.textFieldFillColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(icon: Icons.remove_rounded, onTap: onMinus),
          Container(
            width: 36.w,
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepperButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          width: 36.w,
          height: 36.h,
          child: Icon(icon, color: AppColors.primaryColor, size: 18.sp),
        ),
      ),
    );
  }
}

class _CheckoutFooter extends StatelessWidget {
  const _CheckoutFooter({
    required this.total,
    required this.onCheckout,
  });

  final String total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      decoration: AppDecorations.bottomSheet(),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTexts.total,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  total,
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            PrimaryButton(
              title: AppTexts.checkout,
              icon: Icons.shopping_bag_outlined,
              onPressed: onCheckout,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemShimmer extends StatelessWidget {
  const _CartItemShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.textFieldBorderColor,
      highlightColor: AppColors.white,
      period: const Duration(milliseconds: 1200),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: AppDecorations.card(radius: 16, elevated: false),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 76.w,
                  height: 76.w,
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBorderColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBorderColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 80.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBorderColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Container(
                  width: 90.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBorderColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 108.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.textFieldBorderColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
