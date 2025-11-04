import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../../core/constant/app_colors.dart';

class ProductImageSlider extends StatefulWidget {
  final String? image;
  final String? linkVideo;
  final List<dynamic> gallery;

  const ProductImageSlider({
    super.key,
    this.image,
    this.linkVideo,
    required this.gallery,
  });

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<String> get _allImages {
    final List<String> images = [];

    if (widget.image != null && widget.image!.isNotEmpty) {
      images.add(widget.image!);
    }

    if (widget.gallery.isNotEmpty) {
      for (var item in widget.gallery) {
        if (item is String && item.isNotEmpty) {
          images.add(item);
        } else if (item is Map && item['url'] != null) {
          images.add(item['url'].toString());
        }
      }
    }
    
    return images;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _allImages;
    final hasVideo = widget.linkVideo != null && widget.linkVideo!.isNotEmpty;
    final totalItems = images.length + (hasVideo ? 1 : 0);

    if (totalItems == 0) {
      return Container(
        width: double.infinity,
        height: 300.h,
        color: AppColors.overlayColor,
        child: Icon(
          Icons.image_outlined,
          color: AppColors.greyTextColor,
          size: 60.sp,
        ),
      );
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 300.h,
          color: AppColors.overlayColor,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: totalItems,
            itemBuilder: (context, index) {
              if (hasVideo && index == 0) {
                return _buildVideoItem();
              }
              final imageIndex = hasVideo ? index - 1 : index;
              
              if (imageIndex < images.length) {
                return _buildImageItem(images[imageIndex]);
              }
              return _buildPlaceholder();
            },
          ),
        ),
        if (totalItems > 1)
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                totalItems,
                (index) => Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.primaryColor
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoItem() {
    return GestureDetector(
      onTap: () async {
        if (widget.linkVideo != null && widget.linkVideo!.isNotEmpty) {
          try {
            final uri = Uri.parse(widget.linkVideo!);
            await launcher.launchUrl(
              uri,
              mode: launcher.LaunchMode.externalApplication,
            );
          } catch (e) {
            // Handle any errors silently
            // The video link might not be launchable, but we still show the UI
          }
        }
      },
      child: Container(
        color: AppColors.overlayColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.3),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 80.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppTexts.videoAvailable,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppTexts.tapToPlay,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ),
      errorWidget: (context, url, error) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.overlayColor,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.greyTextColor,
          size: 60.sp,
        ),
      ),
    );
  }
}

