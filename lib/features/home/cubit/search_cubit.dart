import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/products_service.dart';
import '../models/products_list_response_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ProductsService _productsService;

  SearchCubit(this._productsService) : super(SearchInitial());

  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final response = await _productsService.searchProducts(keyword.trim());
      emit(SearchSuccess(response));
    } catch (e) {
      String errorMessage = 'Failed to search. Please try again.';
      if (e is DioException) {
        if (e.response != null) {
          errorMessage = e.response?.statusMessage ?? errorMessage;
        }
      }
      emit(SearchFailure(errorMessage));
    }
  }
}



