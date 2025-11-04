import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/routing/app_routes.dart';
import '../cubit/categories_cubit.dart';
import '../models/category_model.dart';
import 'brand_shimmer_loading.dart';

class BrandsSection extends StatefulWidget {
  const BrandsSection({super.key});

  @override
  State<BrandsSection> createState() => _BrandsSectionState();
}

class _BrandsSectionState extends State<BrandsSection> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'All Brands',
            style: TextStyle(
              color: AppColors.blackTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const BrandShimmerLoading();
            }

            if (state is CategoriesFailure) {
              return SizedBox(
                height: 100.h,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 32.sp),
                      SizedBox(height: 8.h),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CategoriesSuccess) {
              final categories = state.response.data
                  .where(
                    (category) => category.parentId == null && category.active,
                  )
                  .toList();

              if (categories.isEmpty) {
                return SizedBox(
                  height: 100.h,
                  child: Center(
                    child: Text(
                      'No categories available',
                      style: TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildCategoryItem(category);
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(CategoryModel category) {
    final colors = [
      const Color(0xFFFF6B9D),
      const Color(0xFF6C5CE7),
      const Color(0xFF00B894),
      const Color(0xFF0984E3),
      const Color(0xFFE84393),
    ];
    final colorIndex = category.id % colors.length;
    final categoryColor = colors[colorIndex];

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.categoryProducts,
            arguments: {
              'categoryId': category.id,
              'categoryName': category.name,
            },
          );
        },
        child: Column(
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: categoryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: category.image != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: category.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: categoryColor,
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.category_outlined,
                          color: categoryColor,
                          size: 32.sp,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.category_outlined,
                      color: categoryColor,
                      size: 32.sp,
                    ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: 70.w,
              child: Text(
                category.name,
                style: TextStyle(
                  color: AppColors.blackTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
