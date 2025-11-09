import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/localization/language_cubit.dart';
import '../cubit/favorites_cubit.dart';
import '../../home/widgets/product_grid_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Always refresh favorites on first frame when screen is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesCubit>().getFavorites();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh favorites when app comes to foreground
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<FavoritesCubit>().getFavorites();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh favorites whenever dependencies change (e.g., when screen becomes active)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesCubit>().getFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.watch<LanguageCubit>();
    return BlocListener<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        if (state is ToggleFavoriteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.response.message),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh favorites after toggling
          context.read<FavoritesCubit>().getFavorites();
        } else if (state is ToggleFavoriteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
        // Auto-refresh when coming back to this screen
        if (state is FavoritesInitial) {
          context.read<FavoritesCubit>().getFavorites();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: Text(AppTexts.wishlist),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            if (state is FavoritesFailure) {
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
                        context.read<FavoritesCubit>().getFavorites();
                      },
                      child: Text(AppTexts.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is FavoritesSuccess) {
              final favorites = state.response.data;

              if (favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: AppColors.greyTextColor,
                        size: 80.sp,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppTexts.wishlistEmpty,
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppTexts.addItemsToWishlist,
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 14.sp,
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
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favoriteItem = favorites[index];
                  final product = favoriteItem.card;
                  return ProductGridCard(
                    product: product,
                    isFavorite: true,
                    onFavoriteTap: () {
                      context.read<FavoritesCubit>().toggleFavorite(
                        cardId: product.id,
                        method: 'delete',
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
