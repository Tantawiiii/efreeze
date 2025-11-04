import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../cubit/products_cubit.dart';
import '../models/product_model.dart';
import '../../favorites/cubit/favorites_cubit.dart';
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
          // Only show products if they match our section type
          // Since we're calling methods sequentially, we'll show the last loaded data
          products = state.response.data;
        }

        // Get only first 5 products for home screen
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
              height: 280.h,
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
                            return BlocBuilder<FavoritesCubit, FavoritesState>(
                              builder: (context, favoritesState) {
                                // Check if product is in favorites
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
}


