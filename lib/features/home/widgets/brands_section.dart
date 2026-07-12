import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/localization/language_cubit.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_decorations.dart';
import '../../../shared/widgets/section_header.dart';
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
    context.watch<LanguageCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppTexts.allBrands,
          subtitle: AppTexts.onDesTitle1,
        ),
        SizedBox(height: 16.h),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            if (state is CategoriesLoading) {
              return const BrandShimmerLoading();
            }

            if (state is CategoriesFailure) {
              return SizedBox(
                height: 108.h,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.errorColor,
                        size: 28.sp,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
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
                  height: 108.h,
                  child: Center(
                    child: Text(
                      AppTexts.noBrandsAvailable,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 112.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    return _BrandTile(category: categories[index]);
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
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.categoryProducts,
          arguments: {
            'categoryId': category.id,
            'categoryName': category.name,
          },
        );
      },
      child: SizedBox(
        width: 76.w,
        child: Column(
          children: [
            Container(
              width: 76.w,
              height: 76.w,
              padding: EdgeInsets.all(12.w),
              decoration: AppDecorations.card(radius: 16),
              child: category.image != null
                  ? CachedNetworkImage(
                      imageUrl: category.image!,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.storefront_outlined,
                        color: AppColors.primaryColor.withValues(alpha: 0.5),
                        size: 28.sp,
                      ),
                    )
                  : Icon(
                      Icons.storefront_outlined,
                      color: AppColors.primaryColor.withValues(alpha: 0.5),
                      size: 28.sp,
                    ),
            ),
            SizedBox(height: 8.h),
            Text(
              category.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.blackTextColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
