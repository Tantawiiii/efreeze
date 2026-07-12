import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../main.dart';
import '../constant/app_texts.dart';
import '../routing/app_routes.dart';
import '../services/storage_service.dart';
import 'api_constants.dart';

class DioClient {
  DioClient({required StorageService storageService})
    : _storageService = storageService {
    final initialLanguage = storageService.getLanguageCode() ?? 'ar';

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'lang': initialLanguage,
        },
      ),
    );

    _setupInterceptors();
  }

  late final Dio _dio;
  final StorageService _storageService;
  bool _isShowingTokenExpiredDialog = false;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final languageCode = _storageService.getLanguageCode() ?? 'ar';
          options.headers['lang'] = languageCode;
          _dio.options.headers['lang'] = languageCode;
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized errors (token expired)
          // But exclude authentication endpoints (login, register) from token expiration handling
          if (error.response?.statusCode == 401) {
            final requestPath = error.requestOptions.path;
            final isAuthEndpoint =
                requestPath.contains('/api/front/login') ||
                requestPath.contains('/api/front/register') ||
                requestPath.contains('/api/front/signup');

            // Only show token expiration dialog for authenticated endpoints
            if (!isAuthEndpoint) {
              _handleTokenExpiration();
            }
            return handler.next(error);
          }
          return handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  void _handleTokenExpiration() {
    // Prevent multiple dialogs from showing
    if (_isShowingTokenExpiredDialog) {
      return;
    }

    // Clear token and user data
    _storageService.clearAuthData();
    clearAuthToken();

    // Show alert dialog
    final context = navigatorKey.currentContext;
    if (context != null) {
      _isShowingTokenExpiredDialog = true;
      // Use post frame callback to ensure context is valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentContext = navigatorKey.currentContext;
        if (currentContext != null) {
          showDialog(
            context: currentContext,
            barrierDismissible: false,
            builder: (dialogContext) => AlertDialog(
              title: Text(AppTexts.sessionExpired),
              content: Text(AppTexts.sessionExpiredMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _isShowingTokenExpiredDialog = false;
                    Navigator.of(currentContext).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  },
                  child: Text(AppTexts.login),
                ),
              ],
            ),
          ).then((_) {
            // Reset flag when dialog is dismissed
            _isShowingTokenExpiredDialog = false;
          });
        } else {
          _isShowingTokenExpiredDialog = false;
        }
      });
    }
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authentication token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
