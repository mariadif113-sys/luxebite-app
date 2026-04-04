class Category {
  final String id;
  final String nameEn;
  final String nameAr;
  final String nameFr;
  final String icon;

  Category({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.nameFr,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      nameFr: json['name_fr'] ?? json['name_en'], // Fallback
      icon: json['icon'] ?? 'restaurant',
    );
  }
}

class MenuItem {
  final String id;
  final String categoryId;
  final String nameEn;
  final String nameAr;
  final String nameFr;
  final String descriptionEn;
  final String descriptionAr;
  final String descriptionFr;
  final double price;
  final String imageUrl;
  final bool isFeatured;
  final List<Review> reviews;

  MenuItem({
    required this.id,
    required this.categoryId,
    required this.nameEn,
    required this.nameAr,
    required this.nameFr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.price,
    required this.imageUrl,
    this.isFeatured = false,
    this.reviews = const [],
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      categoryId: json['category_id'],
      nameEn: json['name_en'],
      nameAr: json['name_ar'],
      nameFr: json['name_fr'] ?? json['name_en'], // Fallback
      descriptionEn: json['description_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionFr: json['description_fr'] ?? (json['description_en'] ?? ''), // Fallback
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      reviews: [], // Will be populated separately or via join
    );
  }
}

class Offer {
  final String id;
  final String titleEn;
  final String titleAr;
  final String titleFr;
  final String descriptionEn;
  final String descriptionAr;
  final String descriptionFr;
  final int discountPercentage;
  final String imageUrl;
  final DateTime? validUntil;

  Offer({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.titleFr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.descriptionFr,
    required this.discountPercentage,
    required this.imageUrl,
    this.validUntil,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      titleFr: json['title_fr'] ?? json['title_en'], // Fallback
      descriptionEn: json['description_en'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      descriptionFr: json['description_fr'] ?? (json['description_en'] ?? ''), // Fallback
      discountPercentage: json['discount_percentage'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      validUntil: json['valid_until'] != null ? DateTime.parse(json['valid_until']) : null,
    );
  }
}

class Review {
  final String id;
  final String menuItemId;
  final String userId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.menuItemId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      menuItemId: json['menu_item_id'],
      userId: json['user_id'],
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class UserBudget {
  final double monthlyLimit;
  final double currentSpend;

  UserBudget({required this.monthlyLimit, required this.currentSpend});

  double get remaining => monthlyLimit - currentSpend;
  double get percent => monthlyLimit > 0 ? (currentSpend / monthlyLimit) : 0;
}
