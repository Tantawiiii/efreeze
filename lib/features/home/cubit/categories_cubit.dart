import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/categories_service.dart';
import '../models/categories_response_model.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesService _categoriesService;

  CategoriesCubit(this._categoriesService) : super(CategoriesInitial());

  /// Fetch all categories
  Future<void> getCategories() async {
    emit(CategoriesLoading());

    try {
      final response = await _categoriesService.getCategories();

      emit(CategoriesSuccess(response));
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

      emit(CategoriesFailure(errorMessage));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(CategoriesInitial());
  }
}

