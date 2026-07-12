import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_view.dart';
import '../cubit/products_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../widgets/product_model_card.dart';

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
        BlocProvider(
          create: (context) {
            final cubit = di.sl<CartCubit>();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              cubit.getCart();
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
              return AnimatedGridView.builder(
                padding: EdgeInsets.all(20.w),
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.68,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const ProductCardShimmer(inGrid: true);
                },
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

              return RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
                  if (widget.isBestProducts) {
                    await context.read<ProductsCubit>().getBestProducts();
                  } else {
                    await context.read<ProductsCubit>().getAllProducts();
                  }
                },
                child: AnimatedGridView.builder(
                  padding: EdgeInsets.all(20.w),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.68,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductModelCard(
                      product: products[index],
                      inGrid: true,
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
