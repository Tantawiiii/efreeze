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
  final ValueNotifier<int>? refreshTrigger;

  const HomeScreen({super.key, this.refreshTrigger});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _refreshSeed = 0;
  bool _hasRefreshedProducts = false;
  BuildContext? _providersContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _attachRefreshListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _refreshHomeData();
      }
    });
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshTrigger != widget.refreshTrigger) {
      _detachRefreshListener(oldWidget.refreshTrigger);
      _attachRefreshListener();
    }
  }

  @override
  void dispose() {
    _detachRefreshListener(widget.refreshTrigger);
    WidgetsBinding.instance.removeObserver(this);
    _providersContext = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      _refreshHomeData();
    }
  }

  void _attachRefreshListener() {
    widget.refreshTrigger?.addListener(_handleRefreshRequest);
  }

  void _detachRefreshListener(ValueNotifier<int>? notifier) {
    notifier?.removeListener(_handleRefreshRequest);
  }

  void _handleRefreshRequest() {
    if (!mounted) return;
    _refreshHomeData();
  }

  void _refreshHomeData() {
    final providersContext = _providersContext;
    if (providersContext == null) {
      return;
    }

    providersContext.read<CategoriesCubit>().getCategories();
    providersContext.read<OffersCubit>().getOffers();
    providersContext.read<FavoritesCubit>().getFavorites();
    if (_hasRefreshedProducts) {
      setState(() {
        _refreshSeed++;
      });
    } else {
      _hasRefreshedProducts = true;
    }
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<CategoriesCubit>()),
        BlocProvider(create: (context) => di.sl<OffersCubit>()),
        BlocProvider(create: (context) => di.sl<FavoritesCubit>()),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HomeHeader(),
                          const OffersSlider(),
                          const BrandsSection(),
                          SizedBox(height: 24.h),
                          BlocProvider(
                            key: ValueKey('all_products_provider_$_refreshSeed'),
                            create: (context) => di.sl<ProductsCubit>(),
                            child: ProductsSection(
                              key: ValueKey(
                                  'all_products_section_$_refreshSeed'),
                              title: AppTexts.allProducts,
                              isBestProducts: false,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          BlocProvider(
                            key: ValueKey(
                                'best_products_provider_$_refreshSeed'),
                            create: (context) => di.sl<ProductsCubit>(),
                            child: ProductsSection(
                              key: ValueKey(
                                  'best_products_section_$_refreshSeed'),
                              title: AppTexts.bestProducts,
                              isBestProducts: true,
                            ),
                          ),
                          SizedBox(height: 100.h),
                        ],
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
