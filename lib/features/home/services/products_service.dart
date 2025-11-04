import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../models/product_details_response_model.dart';
import '../models/add_to_cart_response_model.dart';
import '../../cart/models/cart_response_model.dart';
import '../../checkout/models/create_order_request_model.dart';
import '../../checkout/models/create_order_response_model.dart';
import '../models/products_list_response_model.dart';
import '../../favorites/models/favorites_response_model.dart';
import '../../favorites/models/add_favorite_response_model.dart';
import '../../reviews/models/add_review_request_model.dart';
import '../../reviews/models/add_review_response_model.dart';
import '../models/offers_response_model.dart';

class ProductsService {
  final ApiService _apiService;

  ProductsService(this._apiService);

  /// Fetch product details by ID
  Future<ProductDetailsResponseModel> getProductDetails(int productId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.cards}/$productId',
      );

      return ProductDetailsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Add product to cart
  /// [method] can be: "add" (first time), "plus" (increase quantity), "minus" (decrease quantity), "delete" (remove item)
  Future<AddToCartResponseModel> addToCart({
    required int productId,
    String method = 'add',
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.cart,
        data: {
          'card_id': productId,
          'method': method,
        },
      );

      return AddToCartResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get cart items
  Future<CartResponseModel> getCart() async {
    try {
      final response = await _apiService.get(ApiConstants.cart);

      return CartResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Create order
  Future<CreateOrderResponseModel> createOrder(
      CreateOrderRequestModel orderData) async {
    try {
      final response = await _apiService.post(
        ApiConstants.createOrder,
        data: orderData.toJson(),
      );

      return CreateOrderResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get products list
  /// [sort] can be null for all products or 'most_popular' for best products
  Future<ProductsListResponseModel> getProducts({String? sort}) async {
    try {
      String endpoint = ApiConstants.cards;
      if (sort != null && sort.isNotEmpty) {
        endpoint = '$endpoint?sort=$sort';
      }

      final response = await _apiService.get(endpoint);

      return ProductsListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Add or remove favorite
  /// [method] can be: "add" or "delete"
  Future<AddFavoriteResponseModel> toggleFavorite({
    required int cardId,
    required String method,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.favorite,
        data: {
          'card_id': cardId,
          'method': method,
        },
      );

      return AddFavoriteResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get all favorites
  Future<FavoritesResponseModel> getFavorites() async {
    try {
      final response = await _apiService.get(ApiConstants.favorite);

      return FavoritesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Add review for a product
  Future<AddReviewResponseModel> addReview({
    required int productId,
    required AddReviewRequestModel reviewData,
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.cards}/$productId/review',
        data: reviewData.toJson(),
      );

      return AddReviewResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get all offers
  Future<OffersResponseModel> getOffers() async {
    try {
      final response = await _apiService.get(ApiConstants.offers);

      return OffersResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Search products by keyword
  Future<ProductsListResponseModel> searchProducts(String keyword) async {
    try {
      final response = await _apiService.get(
        '/api/front/search-cards?keyword=$keyword',
      );

      return ProductsListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}

