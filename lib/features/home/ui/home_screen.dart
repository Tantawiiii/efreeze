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

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<CategoriesCubit>()),
        BlocProvider(create: (context) => di.sl<ProductsCubit>()),
        BlocProvider(
          create: (context) {
            final cubit = di.sl<OffersCubit>();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              cubit.getOffers();
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
                      const ProductsSection(
                        title: 'All Products',
                        isBestProducts: false,
                      ),
                      SizedBox(height: 24.h),
                      const ProductsSection(
                        title: 'Best Products',
                        isBestProducts: true,
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
