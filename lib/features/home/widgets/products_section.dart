import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../cubit/products_cubit.dart';
import '../models/product_model.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../home/services/products_service.dart';
import '../../../core/di/inject.dart' as di;
import 'product_card.dart';

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

        // Check if this section's data is loaded
        if (state is ProductsLoading) {
          isLoading = true;
        } else if (state is ProductsSuccess) {
          products = state.response.data;
        }
        final displayProducts = products.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: AppColors.blackTextColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.showSeeAll && !isLoading)
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.allProducts,
                          arguments: {
                            'title': widget.title,
                            'isBestProducts': widget.isBestProducts,
                          },
                        );
                      },
                      child: Text(
                        'see all',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 300.h,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : displayProducts.isEmpty
                      ? Center(
                          child: Text(
                            'No products available',
                            style: TextStyle(
                              color: AppColors.greyTextColor,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: displayProducts.length,
                          itemBuilder: (context, index) {
                            final product = displayProducts[index];
                            return BlocBuilder<CartCubit, CartState>(
                              builder: (context, cartState) {
                                int cartQuantity = 0;
                                if (cartState is CartSuccess) {
                                  try {
                                    final cartItem = cartState.response.data
                                        .firstWhere(
                                          (item) => item.cardId == product.id,
                                        );
                                    cartQuantity = cartItem.quantity;
                                  } catch (e) {
                                    cartQuantity = 0;
                                  }
                                }

                                return BlocBuilder<FavoritesCubit, FavoritesState>(
                                  builder: (context, favoritesState) {
                                    bool isFavorite = false;
                                    if (favoritesState is FavoritesSuccess) {
                                      isFavorite = favoritesState.response.data
                                          .any((fav) => fav.card.id == product.id);
                                    }

                                    return ProductCard(
                                      title: product.name,
                                      description: product.shortDescription,
                                      currentPrice: '${product.price} ${product.currency}',
                                      originalPrice: '${product.oldPrice} ${product.currency}',
                                      discount: '${product.discount}%',
                                      rating: product.averageRating,
                                      reviewCount: product.reviewsCount,
                                      imageUrl: product.image,
                                      isFavorite: isFavorite,
                                      cartQuantity: cartQuantity > 0 ? cartQuantity : null,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.productDetails,
                                          arguments: {
                                            'productId': product.id,
                                          },
                                        );
                                      },
                                      onFavoriteTap: () {
                                        context.read<FavoritesCubit>().toggleFavorite(
                                              cardId: product.id,
                                              method: isFavorite ? 'delete' : 'add',
                                            );
                                      },
                                      onAddToCart: cartQuantity > 0
                                          ? null
                                          : () {
                                              _addToCart(context, product.id);
                                            },
                                      onRemoveFromCart: cartQuantity > 0
                                          ? () {
                                              _updateCart(context, product.id, 'minus');
                                            }
                                          : null,
                                      onIncreaseQuantity: cartQuantity > 0
                                          ? () {
                                              _updateCart(context, product.id, 'plus');
                                            }
                                          : null,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(BuildContext context, int productId) async {
    final productsService = di.sl<ProductsService>();
    try {
      await productsService.addToCart(productId: productId, method: 'add');
      if (context.mounted) {
        context.read<CartCubit>().getCart();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateCart(BuildContext context, int productId, String method) async {
    final productsService = di.sl<ProductsService>();
    try {
      await productsService.addToCart(productId: productId, method: method);
      if (context.mounted) {
        context.read<CartCubit>().getCart();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cart: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}


