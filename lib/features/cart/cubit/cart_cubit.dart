import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../home/services/products_service.dart';
import '../models/cart_response_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final ProductsService _productsService;

  CartCubit(this._productsService) : super(CartInitial());

  /// Fetch cart items
  Future<void> getCart({bool showLoading = true}) async {
    if (showLoading) {
      emit(CartLoading());
    }

    try {
      final response = await _productsService.getCart();

      emit(CartSuccess(response));
    } catch (e, stackTrace) {
      print('Cart Error: $e');
      print('Stack Trace: $stackTrace');

      String errorMessage = 'An error occurred. Please try again.';

      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          } else if (errorData is Map && errorData.containsKey('error')) {
            errorMessage = errorData['error'].toString();
          } else {
            errorMessage = e.response?.statusMessage ?? errorMessage;
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage =
              'Connection timeout. Please check your internet connection.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        }
      } else {
        errorMessage = e.toString();
        if (e.toString().contains('type') || e.toString().contains('null')) {
          errorMessage = 'Failed to parse cart data. Please try again.';
        }
      }

      emit(CartFailure(errorMessage));
    }
  }

  /// Update cart item quantity or remove it.
  Future<String?> updateCartItem({
    required int cardId,
    required String color,
    required String method,
  }) async {
    try {
      await _productsService.addToCart(
        productId: cardId,
        color: color,
        method: method,
      );
      await getCart(showLoading: false);
      return null;
    } catch (e) {
      String errorMessage = 'Failed to update cart. Please try again.';

      if (e is DioException) {
        if (e.response != null) {
          final errorData = e.response?.data;
          if (errorData is Map && errorData.containsKey('message')) {
            errorMessage = errorData['message'].toString();
          } else if (errorData is Map && errorData.containsKey('error')) {
            errorMessage = errorData['error'].toString();
          }
        }
      }

      return errorMessage;
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CartInitial());
  }
}
