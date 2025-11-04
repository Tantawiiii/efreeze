import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/products_service.dart';
import '../models/product_details_response_model.dart';
import '../models/add_to_cart_response_model.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductsService _productsService;
  ProductDetailsResponseModel? _cachedProductDetails;

  ProductDetailsCubit(this._productsService) : super(ProductDetailsInitial());

  /// Get cached product details
  ProductDetailsResponseModel? get cachedProductDetails => _cachedProductDetails;

  /// Fetch product details by ID
  Future<void> getProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    try {
      final response = await _productsService.getProductDetails(productId);
      _cachedProductDetails = response;

      emit(ProductDetailsSuccess(response));
    } catch (e) {
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
      }

      emit(ProductDetailsFailure(errorMessage));
    }
  }

  /// Add product to cart
  /// [method] can be: "add" (first time), "plus" (increase quantity), "minus" (decrease quantity), "delete" (remove item)
  Future<void> addToCart({
    required int productId,
    String method = 'add',
  }) async {
    emit(AddToCartLoading());

    try {
      final response = await _productsService.addToCart(
        productId: productId,
        method: method,
      );

      emit(AddToCartSuccess(response));
      
      // Restore product details state after showing success
      if (_cachedProductDetails != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(ProductDetailsSuccess(_cachedProductDetails!));
        });
      }
    } catch (e) {
      String errorMessage = 'Failed to add to cart. Please try again.';

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
      }

      emit(AddToCartFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(ProductDetailsInitial());
  }
}

