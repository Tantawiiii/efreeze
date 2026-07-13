import 'package:dio/dio.dart';

/// Parses API error responses (including Laravel validation errors).
abstract final class ApiErrorParser {
  static String parse(
    Object? error, {
    String fallback = 'An error occurred. Please try again.',
  }) {
    if (error is! DioException) {
      return error?.toString() ?? fallback;
    }

    final response = error.response;
    if (response == null) {
      return _connectionMessage(error) ?? fallback;
    }

    final data = response.data;
    if (data is! Map) {
      return response.statusMessage ?? fallback;
    }

    final fieldMessages = _extractFieldErrors(data['errors']);
    if (fieldMessages.isNotEmpty) {
      return fieldMessages.join('\n');
    }

    final message = data['message'];
    if (message != null && message.toString().isNotEmpty) {
      return message.toString();
    }

    final genericError = data['error'];
    if (genericError != null && genericError.toString().isNotEmpty) {
      return genericError.toString();
    }

    return response.statusMessage ?? fallback;
  }

  static List<String> _extractFieldErrors(dynamic errors) {
    if (errors is! Map) return const [];

    final messages = <String>[];
    for (final value in errors.values) {
      if (value is List) {
        for (final item in value) {
          final text = item?.toString().trim();
          if (text != null && text.isNotEmpty) messages.add(text);
        }
      } else {
        final text = value?.toString().trim();
        if (text != null && text.isNotEmpty) messages.add(text);
      }
    }
    return messages;
  }

  static String? _connectionMessage(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    }
    return null;
  }
}
