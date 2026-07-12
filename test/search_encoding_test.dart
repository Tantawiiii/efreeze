import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dio encodes Arabic search keyword via queryParameters', () async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://wsa-panel.wsa-elite.com',
        headers: {'lang': 'ar', 'Accept': 'application/json'},
      ),
    );

    final response = await dio.get<Map<String, dynamic>>(
      '/api/front/search-cards',
      queryParameters: {'keyword': 'مروحة'},
    );

    final data = response.data?['data'] as List<dynamic>? ?? [];
    expect(data.isNotEmpty, isTrue);
  });
}
