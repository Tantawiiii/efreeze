import 'package:efreeze/features/home/models/product_model.dart';
import 'package:efreeze/features/home/models/products_list_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ProductModel parses API card with color as empty list', () {
    final product = ProductModel.fromJson({
      'id': 18,
      'name': 'موتور مروحة 16 وات صيني',
      'slug': 'motor-mroh-16-oat-syny',
      'description': 'desc',
      'short_description': 'short',
      'old_price': '428.00',
      'discount': '30',
      'price': '299.60',
      'currency': 'EGP',
      'quantity': 100,
      'link_video': null,
      'image': 'http://example.com/image.jpg',
      'gallery': ['http://example.com/image.jpg'],
      'category': 'Seif AL-Islam',
      'active': true,
      'average_rating': 0,
      'reviews_count': 0,
      'free_delevery': false,
      'one_year_warranty': false,
      'mobile': '---',
      'type': 'Seif AL-Islam',
      'type_silicone': null,
      'hardness': null,
      'bio': null,
      'time_in_ear': null,
      'end_curing': null,
      'viscosity': null,
      'color': [],
      'packaging': null,
      'item_number': '1001',
      'mix_gun': null,
      'mix_canules': null,
      'createdAt': '2026-05-14 10:43:13 AM',
      'updatedAt': '2026-05-14 12:39:31 PM',
      'deletedAt': null,
    });

    expect(product.id, 18);
    expect(product.color, '');
    expect(product.price, '299.60');
  });

  test('ProductsListResponseModel parses cards response', () {
    final response = ProductsListResponseModel.fromJson({
      'result': 'Success',
      'message': 'Cards fetched successfully',
      'status': 200,
      'data': [
        {
          'id': 18,
          'name': 'Product',
          'slug': 'product',
          'description': 'desc',
          'short_description': 'short',
          'old_price': '100.00',
          'discount': '10',
          'price': '90.00',
          'currency': 'EGP',
          'quantity': 1,
          'link_video': null,
          'image': null,
          'gallery': [],
          'category': 'GR',
          'active': true,
          'average_rating': 0,
          'reviews_count': 0,
          'free_delevery': false,
          'one_year_warranty': false,
          'mobile': '',
          'type': 'GR',
          'type_silicone': null,
          'hardness': null,
          'bio': null,
          'time_in_ear': null,
          'end_curing': null,
          'viscosity': null,
          'color': [],
          'packaging': null,
          'item_number': '1',
          'mix_gun': null,
          'mix_canules': null,
          'createdAt': '2026-05-14 10:43:13 AM',
          'updatedAt': '2026-05-14 12:39:31 PM',
          'deletedAt': null,
        },
      ],
    });

    expect(response.data, hasLength(1));
    expect(response.data.first.color, '');
  });

  test('displayImage falls back to gallery when image is null', () {
    final product = ProductModel.fromJson({
      'id': 31,
      'name': 'اوفر لود',
      'slug': 'aofr-lod',
      'description': 'desc',
      'short_description': 'short',
      'old_price': '23.00',
      'discount': '20',
      'price': '18.40',
      'currency': 'EGP',
      'quantity': 100,
      'link_video': null,
      'image': null,
      'gallery': [
        'http://back.solunile.com/storage/cards/gallery/DXp2iPXXPLT5d07LfY1WRCZWUqLHxH5IIRdRfcFl.jpg',
      ],
      'category': 'Seif AL-Islam',
      'active': true,
      'average_rating': 0,
      'reviews_count': 0,
      'free_delevery': false,
      'one_year_warranty': false,
      'mobile': '',
      'type': 'Seif AL-Islam',
      'type_silicone': null,
      'hardness': null,
      'bio': null,
      'time_in_ear': null,
      'end_curing': null,
      'viscosity': null,
      'color': null,
      'packaging': null,
      'item_number': '1014',
      'mix_gun': null,
      'mix_canules': null,
      'created_at': '2026-05-14T12:19:00.000000Z',
      'updated_at': '2026-05-14T12:38:25.000000Z',
      'deletedAt': null,
    });

    expect(
      product.displayImage,
      'http://back.solunile.com/storage/cards/gallery/DXp2iPXXPLT5d07LfY1WRCZWUqLHxH5IIRdRfcFl.jpg',
    );
  });
}
