import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../cubit/products_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../widgets/product_grid_card.dart';

class AllProductsScreen extends StatefulWidget {
  final String title;
  final bool isBestProducts;

  const AllProductsScreen({
    super.key,
    required this.title,
    this.isBestProducts = false,
  });

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = di.sl<ProductsCubit>();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (widget.isBestProducts) {
                cubit.getBestProducts();
              } else {
                cubit.getAllProducts();
              }
            });
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = di.sl<FavoritesCubit>();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              cubit.getFavorites();
            });
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            if (state is ProductsFailure) {
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
                        if (widget.isBestProducts) {
                          context.read<ProductsCubit>().getBestProducts();
                        } else {
                          context.read<ProductsCubit>().getAllProducts();
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductsSuccess) {
              final products = state.response.data;

              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.greyTextColor,
                        size: 80.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No products found',
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(20.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 0.6,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, favoritesState) {
                      bool isFavorite = false;
                      if (favoritesState is FavoritesSuccess) {
                        isFavorite = favoritesState.response.data
                            .any((fav) => fav.card.id == product.id);
                      }

                      return ProductGridCard(
                        product: product,
                        isFavorite: isFavorite,
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
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

