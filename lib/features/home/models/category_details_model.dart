import 'category_model.dart';
import 'product_model.dart';

class CategoryDetailsModel {
  final int id;
  final String name;
  final String slug;
  final int? parentId;
  final bool active;
  final String? image;
  final List<ProductModel> products;
  final List<CategoryModel> children;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  CategoryDetailsModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    required this.active,
    this.image,
    required this.products,
    required this.children,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      parentId: json['parent_id'] as int?,
      active: json['active'] as bool,
      image: json['image'] as String?,
      products:
          (json['products'] as List<dynamic>?)
              ?.map(
                (product) =>
                    ProductModel.fromJson(product as Map<String, dynamic>),
              )
              .toList() ??
          [],
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (child) =>
                    CategoryModel.fromJson(child as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'parent_id': parentId,
      'active': active,
      'image': image,
      'products': products.map((product) => product.toJson()).toList(),
      'children': children.map((child) => child.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}
