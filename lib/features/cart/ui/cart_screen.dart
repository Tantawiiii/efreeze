import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../cubit/cart_cubit.dart';
import '../../home/services/products_service.dart';
import '../models/cart_item_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<CartCubit>();
        if (cubit.state is CartInitial) {
          cubit.getCart();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartInitial || state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is CartFailure) {
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
                      context.read<CartCubit>().getCart();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CartSuccess) {
            final cartItems = state.response.data;

            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.greyTextColor,
                      size: 80.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add items to your cart to see them here',
                      style: TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20.w),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return _buildCartItem(cartItem);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: AppColors.blackTextColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _calculateTotal(cartItems),
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.checkout,
                              arguments: cartItems,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCartItem(CartItemModel cartItem) {
    final product = cartItem.card;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.overlayColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: product.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
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
                        size: 30.sp,
                      ),
                    ),
                  )
                : Icon(
                    Icons.image_outlined,
                    color: AppColors.greyTextColor,
                    size: 30.sp,
                  ),
          ),
          SizedBox(width: 12.w),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: AppColors.blackTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${product.price} ${product.currency}',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                // Quantity Controls
                Row(
                  children: [
                    _buildQuantityButton(
                      icon: Icons.remove,
                      onTap: () {
                        _updateQuantity(cartItem.cardId, 'minus');
                      },
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      cartItem.quantity.toString(),
                      style: TextStyle(
                        color: AppColors.blackTextColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    _buildQuantityButton(
                      icon: Icons.add,
                      onTap: () {
                        _updateQuantity(cartItem.cardId, 'plus');
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _updateQuantity(cartItem.cardId, 'delete');
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: AppColors.overlayColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 18.sp),
      ),
    );
  }

  void _updateQuantity(int cardId, String method) async {
    final productsService = di.sl<ProductsService>();
    try {
      await productsService.addToCart(productId: cardId, method: method);
      if (mounted) {
        context.read<CartCubit>().getCart();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cart: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _calculateTotal(List<CartItemModel> cartItems) {
    double total = 0.0;
    String currency = 'EGP';

    for (var item in cartItems) {
      final product = item.card;
      final quantity = item.quantity;
      final price = double.tryParse(product.price) ?? 0.0;
      total += price * quantity;
      currency = product.currency;
    }

    return '${total.toStringAsFixed(2)} $currency';
  }
}
