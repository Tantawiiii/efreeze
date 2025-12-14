import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constant/app_colors.dart';
import '../../core/di/inject.dart' as di;
import '../../features/favorites/cubit/favorites_cubit.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;
  final VoidCallback? onTap;

  const FavoriteButton({super.key, required this.productId, this.onTap});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  bool? _optimisticFavorite;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _getFavoriteState(FavoritesState state) {
    if (_optimisticFavorite != null) {
      return _optimisticFavorite!;
    }
    if (state is FavoritesSuccess) {
      return state.response.data.any((fav) => fav.card.id == widget.productId);
    }
    return false;
  }

  void _handleTap(BuildContext context, bool currentFavorite) {
    setState(() {
      _optimisticFavorite = !currentFavorite;
    });

    // Animate the tap
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      // Toggle favorite directly
      try {
        context
            .read<FavoritesCubit>()
            .toggleFavorite(
              cardId: widget.productId,
              method: currentFavorite ? 'delete' : 'add',
            )
            .then((_) {
              // Clear optimistic state after API call completes
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _optimisticFavorite = null;
                    });
                  }
                });
              }
            })
            .catchError((error) {
              // Revert optimistic update on error
              if (mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _optimisticFavorite = null;
                    });
                  }
                });
              }
            });
      } catch (e) {
        // FavoritesCubit not available in context
        debugPrint('FavoritesCubit not found in context: $e');
        // Revert optimistic update
        if (mounted) {
          setState(() {
            _optimisticFavorite = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always use the singleton FavoritesCubit
    final favoritesCubit = di.sl<FavoritesCubit>();

    // Provide it using BlocProvider.value to ensure it's always available
    return BlocProvider.value(
      value: favoritesCubit,
      child: BlocSelector<FavoritesCubit, FavoritesState, bool>(
        selector: _getFavoriteState,
        builder: (context, isFavorite) {
          return _buildFavoriteIconWidget(isFavorite, context);
        },
      ),
    );
  }

  Widget _buildFavoriteIconWidget(bool isFavorite, BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Bounce(
        onTap: () => _handleTap(context, isFavorite),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Container(
            key: ValueKey(isFavorite),
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : AppColors.greyTextColor,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
