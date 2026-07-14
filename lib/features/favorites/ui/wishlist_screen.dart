import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/localization/language_cubit.dart';
import '../../../core/ui/app_shell.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/empty_state.dart';
import '../cubit/favorites_cubit.dart';
import '../../home/widgets/product_model_card.dart';
import '../../../shared/widgets/animated_list_view.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoritesCubit>().getFavorites();
    });
  }

  EdgeInsets _gridPadding(BuildContext context) {
    final bottomInset = AppShell.bottomOverlayOf(context);
    return EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 12.w + bottomInset + 20.h);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    context.watch<LanguageCubit>();

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        title: Text(AppTexts.wishlist),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesInitial || state is FavoritesLoading) {
            return AnimatedGridView.builder(
              padding: _gridPadding(context),
              crossAxisCount: 2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.62,
              itemCount: 6,
              itemBuilder: (context, index) {
                return const ProductCardShimmer(inGrid: true);
              },
            );
          }

          if (state is FavoritesFailure) {
            return EmptyState(
              icon: Icons.error_outline_rounded,
              title: state.message,
              actionLabel: AppTexts.retry,
              onAction: () =>
                  context.read<FavoritesCubit>().getFavorites(forceRefresh: true),
            );
          }

          if (state is FavoritesSuccess) {
            final favorites = state.items;

            if (favorites.isEmpty) {
              return EmptyState(
                icon: Icons.favorite_border_rounded,
                title: AppTexts.wishlistEmpty,
                subtitle: AppTexts.addItemsToWishlist,
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: () async {
                await context.read<FavoritesCubit>().getFavorites(
                  forceRefresh: true,
                );
              },
              child: AnimatedGridView.builder(
                padding: _gridPadding(context),
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.62,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final product = favorites[index].card;
                  return ProductModelCard(
                    key: ValueKey('wishlist_${product.id}'),
                    product: product,
                    inGrid: true,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
