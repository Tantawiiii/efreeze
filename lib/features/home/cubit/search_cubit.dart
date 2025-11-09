import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/products_service.dart';
import '../models/products_list_response_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ProductsService _productsService;
  ProductsListResponseModel? _initialProducts;

  SearchCubit(this._productsService) : super(SearchInitial());

  Future<void> loadInitialProducts() async {
    if (_initialProducts != null) {
      emit(SearchSuccess(_initialProducts!));
      return;
    }

    emit(SearchLoading());
    try {
      final response = await _productsService.getProducts();
      _initialProducts = response;
      emit(SearchSuccess(response));
    } catch (e) {
      String errorMessage = 'Failed to load products. Please try again.';
      if (e is DioException) {
        if (e.response != null) {
          errorMessage = e.response?.statusMessage ?? errorMessage;
        }
      }
      emit(SearchFailure(errorMessage));
    }
  }

  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) {
      if (_initialProducts != null) {
        emit(SearchSuccess(_initialProducts!));
      } else {
        await loadInitialProducts();
      }
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







