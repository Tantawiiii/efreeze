import 'package:flutter/material.dart';

import 'page_transitions.dart';
import '../../features/auth/ui/login_screen.dart';
import 'app_routes.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';

import '../../features/auth/ui/signup_screen.dart';
import '../../features/home/ui/main_navigation_screen.dart';
import '../../features/home/ui/category_products_screen.dart';
import '../../features/home/ui/product_details_screen.dart';
import '../../features/cart/ui/cart_screen.dart';
import '../../features/checkout/ui/checkout_screen.dart';
import '../../features/cart/models/cart_item_model.dart';
import '../../features/home/ui/all_products_screen.dart';
import '../../features/reviews/ui/add_review_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/settings/ui/user_info_screen.dart';
import '../../features/orders/ui/order_details_screen.dart';

Route<dynamic> onGenerateAppRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return fadeSlideRoute(page: const SplashScreen(), settings: settings);
    case AppRoutes.onboarding:
      return fadeSlideRoute(page: const OnboardingScreen(), settings: settings);
    case AppRoutes.login:
      return fadeSlideRoute(page: const LoginScreen(), settings: settings);
    case AppRoutes.signup:
      return fadeSlideRoute(page: const SignupScreen(), settings: settings);
    case AppRoutes.home:
      return scaleFadeRoute(
        page: const MainNavigationScreen(),
        settings: settings,
      );
    case AppRoutes.categoryProducts:
      final args = settings.arguments as Map<String, dynamic>?;
      return fadeSlideRoute(
        settings: settings,
        page: CategoryProductsScreen(
          categoryId: args?['categoryId'] as int,
          categoryName: args?['categoryName'] as String? ?? 'Products',
        ),
      );
    case AppRoutes.productDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      return scaleFadeRoute(
        settings: settings,
        page: ProductDetailsScreen(productId: args?['productId'] as int),
      );
    case AppRoutes.cart:
      return fadeSlideRoute(page: const CartScreen(), settings: settings);
    case AppRoutes.checkout:
      final args = settings.arguments as List<CartItemModel>?;
      return fadeSlideRoute(
        settings: settings,
        page: CheckoutScreen(cartItems: args ?? []),
      );
    case AppRoutes.allProducts:
      final args = settings.arguments as Map<String, dynamic>?;
      return fadeSlideRoute(
        settings: settings,
        page: AllProductsScreen(
          title: args?['title'] as String? ?? 'All Products',
          isBestProducts: args?['isBestProducts'] as bool? ?? false,
        ),
      );
    case AppRoutes.addReview:
      final args = settings.arguments as Map<String, dynamic>?;
      return fadeSlideRoute(
        settings: settings,
        page: AddReviewScreen(productId: args?['productId'] as int),
      );
    case AppRoutes.settings:
      return fadeSlideRoute(page: const SettingsScreen(), settings: settings);
    case AppRoutes.userInfo:
      return fadeSlideRoute(page: const UserInfoScreen(), settings: settings);
    case AppRoutes.orderDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      return fadeSlideRoute(
        settings: settings,
        page: OrderDetailsScreen(
          orderNumber: args?['orderNumber'] as String? ?? '',
        ),
      );
    default:
      return fadeSlideRoute(
        settings: settings,
        page: const Scaffold(
          body: Center(child: Text('Route not found')),
        ),
      );
  }
}
