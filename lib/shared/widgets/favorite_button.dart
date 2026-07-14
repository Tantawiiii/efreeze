import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constant/app_colors.dart';
import '../../core/di/inject.dart' as di;
import '../../features/favorites/cubit/favorites_cubit.dart';
import 'app_snackbar.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;
  final VoidCallback? onTap;

  const FavoriteButton({super.key, required this.productId, this.onTap});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  bool _isToggling = false;

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

  Future<void> _handleTap(BuildContext context, bool isFavorite) async {
    if (_isToggling) return;

    _isToggling = true;
    _animationController.forward().then((_) {
      if (mounted) _animationController.reverse();
    });

    if (widget.onTap != null) {
      widget.onTap!();
      _isToggling = false;
      return;
    }

    final cubit = context.read<FavoritesCubit>();
    final error = await cubit.toggleFavorite(
      cardId: widget.productId,
      method: isFavorite ? 'delete' : 'add',
    );

    if (!context.mounted) return;

    if (error != null) {
      AppSnackbar.error(context, error);
    }

    _isToggling = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<FavoritesCubit>(),
      child: BlocSelector<FavoritesCubit, FavoritesState, bool>(
        selector: (state) {
          if (state is FavoritesSuccess) {
            return state.isFavorite(widget.productId);
          }
          return false;
        },
        builder: (context, isFavorite) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: Bounce(
              onTap: () => _handleTap(context, isFavorite),
              child: Container(
                key: ValueKey('favorite_${widget.productId}_$isFavorite'),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppColors.greyTextColor,
                  size: 20.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
