import 'package:flutter/material.dart';

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
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case AppRoutes.onboarding:
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case AppRoutes.signup:
      return MaterialPageRoute(builder: (_) => const SignupScreen());
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
    case AppRoutes.categoryProducts:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(
          categoryId: args?['categoryId'] as int,
          categoryName: args?['categoryName'] as String? ?? 'Products',
        ),
      );
    case AppRoutes.productDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) =>
            ProductDetailsScreen(productId: args?['productId'] as int),
      );
    case AppRoutes.cart:
      return MaterialPageRoute(builder: (_) => const CartScreen());
    case AppRoutes.checkout:
      final args = settings.arguments as List<CartItemModel>?;
      return MaterialPageRoute(
        builder: (_) => CheckoutScreen(cartItems: args ?? []),
      );
    case AppRoutes.allProducts:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => AllProductsScreen(
          title: args?['title'] as String? ?? 'All Products',
          isBestProducts: args?['isBestProducts'] as bool? ?? false,
        ),
      );
    case AppRoutes.addReview:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => AddReviewScreen(productId: args?['productId'] as int),
      );
    case AppRoutes.settings:
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    case AppRoutes.userInfo:
      return MaterialPageRoute(builder: (_) => const UserInfoScreen());
    case AppRoutes.orderDetails:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(
          orderNumber: args?['orderNumber'] as String? ?? '',
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      );
  }
}
