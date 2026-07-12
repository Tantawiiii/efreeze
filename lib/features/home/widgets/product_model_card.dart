import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/inject.dart' as di;
import '../../../core/routing/app_routes.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../models/product_model.dart';
import '../services/products_service.dart';
import 'product_card.dart';

class ProductModelCard extends StatelessWidget {
  final ProductModel product;
  final bool inGrid;

  const ProductModelCard({
    super.key,
    required this.product,
    this.inGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        var cartQuantity = 0;
        if (cartState is CartSuccess) {
          try {
            cartQuantity = cartState.response.data
                .firstWhere((item) => item.cardId == product.id)
                .quantity;
          } catch (_) {
            cartQuantity = 0;
          }
        }

        return ProductCard(
          inGrid: inGrid,
          productId: product.id,
          title: product.name,
          description: product.shortDescription,
          currentPrice: '${product.price} ${product.currency}',
          originalPrice: '${product.oldPrice} ${product.currency}',
          discount: '${product.discount}%',
          rating: product.averageRating,
          reviewCount: product.reviewsCount,
          imageUrl: product.displayImage,
          cartQuantity: cartQuantity > 0 ? cartQuantity : null,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.productDetails,
              arguments: {'productId': product.id},
            );
          },
          onAddToCart: cartQuantity > 0
              ? null
              : () => _updateCart(context, product.id, product.color, 'add'),
          onRemoveFromCart: cartQuantity > 0
              ? () => _updateCart(context, product.id, product.color, 'minus')
              : null,
          onIncreaseQuantity: cartQuantity > 0
              ? () => _updateCart(context, product.id, product.color, 'plus')
              : null,
        );
      },
    );
  }

  Future<void> _updateCart(
    BuildContext context,
    int productId,
    String color,
    String method,
  ) async {
    final productsService = di.sl<ProductsService>();
    try {
      await productsService.addToCart(
        productId: productId,
        color: color,
        method: method,
      );
      if (context.mounted) {
        context.read<CartCubit>().getCart(showLoading: false);
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Failed to update cart: ${e.toString()}');
      }
    }
  }
}
