import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/categories_service.dart';
import '../models/category_details_response_model.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends Cubit<CategoryProductsState> {
  final CategoriesService _categoriesService;

  CategoryProductsCubit(this._categoriesService)
      : super(CategoryProductsInitial());

  /// Fetch category by ID with products
  Future<void> getCategoryById(int categoryId) async {
    emit(CategoryProductsLoading());

    try {
      final response = await _categoriesService.getCategoryById(categoryId);

      emit(CategoryProductsSuccess(response));
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

      emit(CategoryProductsFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CategoryProductsInitial());
  }
}

