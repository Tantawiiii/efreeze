import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
import '../models/categories_response_model.dart';
import '../models/category_details_response_model.dart';

class CategoriesService {
  final ApiService _apiService;

  CategoriesService(this._apiService);

  /// Fetch all categories
  Future<CategoriesResponseModel> getCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.categories);

      return CategoriesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch category by ID with products
  Future<CategoryDetailsResponseModel> getCategoryById(int categoryId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.categories}/$categoryId',
      );

      return CategoryDetailsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}

