import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../services/products_service.dart';
import '../models/products_list_response_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._productsService) : super(SearchInitial());

  final ProductsService _productsService;
  ProductsListResponseModel? _initialProducts;
  CancelToken? _searchCancelToken;

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
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      _searchCancelToken?.cancel();
      _searchCancelToken = null;
      if (_initialProducts != null) {
        emit(SearchSuccess(_initialProducts!));
      } else {
        await loadInitialProducts();
      }
      return;
    }

    _searchCancelToken?.cancel();
    _searchCancelToken = CancelToken();

    emit(SearchLoading());
    try {
      final response = await _productsService.searchProducts(
        trimmed,
        cancelToken: _searchCancelToken,
      );
      emit(SearchSuccess(response));
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        return;
      }

      String errorMessage = 'Failed to search. Please try again.';
      if (e is DioException && e.response != null) {
        errorMessage = e.response?.statusMessage ?? errorMessage;
      }
      emit(SearchFailure(errorMessage));
    }
  }

  @override
  Future<void> close() {
    _searchCancelToken?.cancel();
    return super.close();
  }
}
