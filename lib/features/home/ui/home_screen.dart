import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../cubit/categories_cubit.dart';
import '../cubit/products_cubit.dart';
import '../cubit/offers_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../widgets/home_header.dart';
import '../widgets/brands_section.dart';
import '../widgets/offers_slider.dart';
import '../widgets/products_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    // Load data only if not already loaded (cached)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _providersContext != null) {
        _loadHomeDataIfNeeded();
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Removed auto-refresh on app resume - data is cached
  }

  void _loadHomeDataIfNeeded() {
    final providersContext = _providersContext;
    if (providersContext == null) {
      return;
    }

    // Load only if not already loaded (will be skipped if cached)
    providersContext.read<CategoriesCubit>().getCategories();
    providersContext.read<OffersCubit>().getOffers();
    providersContext.read<FavoritesCubit>().getFavorites();
  }

  Future<void> _refreshHomeData() async {
    final providersContext = _providersContext;
    if (providersContext == null) {
      return;
    }

    // Force refresh all data on pull-to-refresh
    await Future.wait([
      providersContext.read<CategoriesCubit>().getCategories(
        forceRefresh: true,
      ),
      providersContext.read<OffersCubit>().getOffers(forceRefresh: true),
      providersContext.read<FavoritesCubit>().getFavorites(forceRefresh: true),
    ]);

    if (!mounted) return;

    // Update refresh seed to force rebuild of product sections
    setState(() {
      _refreshSeed++;
    });
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Use BlocProvider.value for singleton cubits to prevent auto-closing
        BlocProvider.value(value: di.sl<CategoriesCubit>()),
        BlocProvider.value(value: di.sl<OffersCubit>()),
        BlocProvider.value(value: di.sl<FavoritesCubit>()),
      ],
      child: Builder(
        builder: (ctx) {
          _providersContext = ctx;
          return Scaffold(
            backgroundColor: AppColors.white,
            extendBody: true,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryColor,
                      onRefresh: _refreshHomeData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const HomeHeader(),
                            const OffersSlider(),
                            const BrandsSection(),
                            SizedBox(height: 24.h),
                            BlocProvider(
                              key: ValueKey(
                                'all_products_provider_$_refreshSeed',
                              ),
                              create: (context) => di.sl<ProductsCubit>(),
                              child: ProductsSection(
                                key: ValueKey(
                                  'all_products_section_$_refreshSeed',
                                ),
                                title: AppTexts.allProducts,
                                isBestProducts: false,
                              ),
                            ),
                            SizedBox(height: 24.h),
                            BlocProvider(
                              key: ValueKey(
                                'best_products_provider_$_refreshSeed',
                              ),
                              create: (context) => di.sl<ProductsCubit>(),
                              child: ProductsSection(
                                key: ValueKey(
                                  'best_products_section_$_refreshSeed',
                                ),
                                title: AppTexts.bestProducts,
                                isBestProducts: true,
                              ),
                            ),
                            SizedBox(height: 100.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
