import 'package:efreeze/core/constant/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';
import '../../core/routing/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  List<_OnboardData> get _pages =>  [
        _OnboardData(
          image: AppAssets.onboard1Img,
          title: AppTexts.onTitle1,
          subtitle:AppTexts.onDesTitle1,
        ),
        _OnboardData(
          image: AppAssets.onboard2Img,
          title: AppTexts.onTitle2,
          subtitle:AppTexts.onDesTitle2,
        ),
        _OnboardData(
          image: AppAssets.onboard3Img,
          title: AppTexts.onTitle3,
          subtitle:AppTexts.onDesTitle3,
        ),
      ];

  void _goNext() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Text('${_index + 1}/${_pages.length}',
                      style: TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 14.sp,
                      )),
                  const Spacer(),
                  TextButton(onPressed: _skip, child: const Text(AppTexts.skip)),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardPage(data: _pages[i]),
              ),
            ),
            SizedBox(height: 12.h),
            _Dots(index: _index, length: _pages.length),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _index == 0
                        ? null
                        : () => _controller.previousPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            ),
                    child: const Text(AppTexts.prev),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _goNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: Size(120.w, 44.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      _index == _pages.length - 1 ? AppTexts.getStarted : AppTexts.next,
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.index, required this.length});
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final bool active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: active ? 22.w : 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: active ? AppColors.primaryColor : AppColors.textFieldBorderColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
        );
      }),
    );
  }
}

class _OnboardData {
  const _OnboardData({required this.image, required this.title, required this.subtitle});
  final String image;
  final String title;
  final String subtitle;
}

class _OnboardPage extends StatelessWidget {
  const _OnboardPage({required this.data});
  final _OnboardData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                data.image,
                width: 260.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.blackTextColor,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyTextColor,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}


