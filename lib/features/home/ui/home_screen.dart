import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../../favorites/cubit/favorites_cubit.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/offers_cubit.dart';
import '../cubit/products_cubit.dart';
import '../widgets/brands_section.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/offers_slider.dart';
import '../widgets/products_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onSearchTap});

  final VoidCallback? onSearchTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _refreshSeed = 0;
  BuildContext? _providersContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _providersContext != null) {
        _loadHomeDataIfNeeded();
        _loadCartCount();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _providersContext = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  void _loadHomeDataIfNeeded() {
    final providersContext = _providersContext;
    if (providersContext == null) {
      return;
    }

    providersContext.read<CategoriesCubit>().getCategories();
    providersContext.read<OffersCubit>().getOffers();
    providersContext.read<FavoritesCubit>().getFavorites();
  }

  void _loadCartCount() {
    context.read<CartCubit>().getCart(showLoading: false);
  }

  Future<void> _refreshHomeData() async {
    final providersContext = _providersContext;
    if (providersContext == null) {
      return;
    }

    await Future.wait([
      providersContext.read<CategoriesCubit>().getCategories(
        forceRefresh: true,
      ),
      providersContext.read<OffersCubit>().getOffers(forceRefresh: true),
      providersContext.read<FavoritesCubit>().getFavorites(forceRefresh: true),
      context.read<CartCubit>().getCart(showLoading: false),
    ]);

    if (!mounted) return;

    setState(() {
      _refreshSeed++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: di.sl<CategoriesCubit>()),
        BlocProvider.value(value: di.sl<OffersCubit>()),
        BlocProvider.value(value: di.sl<FavoritesCubit>()),
      ],
      child: Builder(
        builder: (ctx) {
          _providersContext = ctx;
          return Scaffold(
            backgroundColor: AppColors.whiteBackground,
            extendBody: true,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: _refreshHomeData,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const HomeHeader(),
                          HomeSearchBar(onTap: widget.onSearchTap),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: OffersSlider()),
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    const SliverToBoxAdapter(child: BrandsSection()),
                    SliverToBoxAdapter(child: SizedBox(height: 28.h)),
                    SliverToBoxAdapter(
                      child: BlocProvider(
                        key: ValueKey('all_products_provider_$_refreshSeed'),
                        create: (context) => di.sl<ProductsCubit>(),
                        child: ProductsSection(
                          key: ValueKey('all_products_section_$_refreshSeed'),
                          title: AppTexts.allProducts,
                          isBestProducts: false,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 28.h)),
                    SliverToBoxAdapter(
                      child: BlocProvider(
                        key: ValueKey('best_products_provider_$_refreshSeed'),
                        create: (context) => di.sl<ProductsCubit>(),
                        child: ProductsSection(
                          key: ValueKey(
                            'best_products_section_$_refreshSeed',
                          ),
                          title: AppTexts.bestProducts,
                          isBestProducts: true,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
