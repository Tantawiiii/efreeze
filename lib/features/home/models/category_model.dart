class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final int? parentId;
  final bool active;
  final String? image;
  final List<CategoryModel> children;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.parentId,
    required this.active,
    this.image,
    required this.children,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      parentId: json['parent_id'] as int?,
      active: json['active'] as bool,
      image: json['image'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map((child) => CategoryModel.fromJson(child as Map<String, dynamic>))
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
      'children': children.map((child) => child.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }
}

