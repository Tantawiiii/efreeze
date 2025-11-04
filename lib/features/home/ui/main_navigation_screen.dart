import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/di/inject.dart' as di;
import '../widgets/bottom_nav_bar.dart';
import '../ui/home_screen.dart';
import '../../cart/ui/cart_screen.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../favorites/ui/wishlist_screen.dart';
import '../../favorites/cubit/favorites_cubit.dart';
import '../ui/search_screen.dart';
import '../cubit/search_cubit.dart';
import '../../settings/ui/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 2;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildWishlistScreen(),
      _buildCartScreen(),
      _buildHomeScreen(),
      _buildSearchScreen(),
      _buildSettingsScreen(),
    ];
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1 || index == 0) {
      // Refresh cart And FAv data when
      WidgetsBinding.instance.addPostFrameCallback((_) {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CartCubit>()..getCart(),
        ),
        BlocProvider(
          create: (context) => di.sl<FavoritesCubit>(),
        ),
        BlocProvider(
          create: (context) => di.sl<SearchCubit>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onNavItemTapped,
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return const HomeScreen();
  }

  Widget _buildCartScreen() {
    return const CartScreen(key: ValueKey('cart_screen'));
  }

  Widget _buildWishlistScreen() {
    return const WishlistScreen(key: ValueKey('wishlist_screen'));
  }

  Widget _buildSearchScreen() {
    return const SearchScreen(key: ValueKey('search_screen'));
  }

  Widget _buildSettingsScreen() {
    return const SettingsScreen(key: ValueKey('settings_screen'));
  }
}

