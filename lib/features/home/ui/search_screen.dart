import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_colors.dart';
import '../cubit/search_cubit.dart';
import '../widgets/product_grid_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      context.read<SearchCubit>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.textFieldBorderColor),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1.4),
                    borderRadius: BorderRadius.circular(10.r),
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
                          'Start typing to search products',
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
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

                    final products =
                        (state as SearchSuccess).response.data;

                    if (products.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(
                            color: AppColors.greyTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 6.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductGridCard(product: product);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}


