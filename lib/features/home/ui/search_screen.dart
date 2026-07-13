import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_texts.dart';
import '../../../core/localization/language_cubit.dart';
import '../../../core/ui/app_shell.dart';
import '../../../core/di/inject.dart' as di;
import '../../../shared/widgets/shimmer_loading.dart';
import '../../../shared/widgets/animated_list_view.dart';
import '../cubit/search_cubit.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../widgets/product_model_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SearchCubit>().loadInitialProducts();
      di.sl<FavoritesCubit>().getFavorites();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onSearchTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_controller.value.composing.isValid) {
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      context.read<SearchCubit>().search(_controller.text);
    });
  }

  EdgeInsets _gridPadding(BuildContext context) {
    final bottomInset = AppShell.bottomOverlayOf(context);
    return EdgeInsets.fromLTRB(12.w, 12.w, 12.w, 12.w + bottomInset + 20.h);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageCubit>();
    return BlocProvider.value(
      value: di.sl<FavoritesCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.whiteBackground,
        appBar: AppBar(title: Text(AppTexts.search)),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  _debounce?.cancel();
                  context.read<SearchCubit>().search(value);
                },
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: AppTexts.searchProductsHint,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.greyTextColor,
                  ),
                  filled: true,
                  fillColor: AppColors.textFieldFillColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.textFieldBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return Center(
                        child: Text(
                          AppTexts.startTypingToSearchProducts,
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    if (state is SearchLoading) {
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

                    if (state is SearchFailure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    final products = (state as SearchSuccess).response.data;

                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          AppTexts.noResultsFound,
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return AnimatedGridView.builder(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 0.62,
                      padding: _gridPadding(context),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductModelCard(
                          product: products[index],
                          inGrid: true,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
