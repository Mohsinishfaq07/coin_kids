import 'package:cloud_firestore/cloud_firestore.dart';

import 'market_product_model.dart';

class WishlistModel {
  final String? id;
  final String userId;
  final String productId;
  final DateTime addedAt;
  final bool isPriority;
  final MarketProductModel? product; // Optional cached product data

  WishlistModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.addedAt,
    this.isPriority = false,
    this.product,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json, {String? id, MarketProductModel? product}) {
    MarketProductModel? productModel;
    
    if (json['product'] != null) {
      final productData = json['product'] as Map<String, dynamic>;
      productModel = MarketProductModel(
        id: productData['id'],
        name: productData['name'] ?? '',
        price: (productData['price'] ?? 0.0).toDouble(),
        imageUrl: productData['image_url'] ?? '',
        about: (productData['about'] as List<dynamic>?)?.cast<String>() ?? [],
        minAge: productData['min_age'] ?? 0,
        maxAge: productData['max_age'] ?? 18,
        url: productData['url'] ?? '',
        rating: productData['rating']?.toDouble(),
      );
    }

    return WishlistModel(
      id: id,
      userId: json['userId'] ?? '',
      productId: json['productId'] ?? '',
      addedAt: (json['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPriority: json['isPriority'] ?? false,
      product: product ?? productModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'productId': productId,
      'addedAt': Timestamp.fromDate(addedAt),
      'isPriority': isPriority,
      // Store complete product data if available
      if (product != null)
        'product': {
          'id': product!.id,
          'name': product!.name,
          'price': product!.price,
          'image_url': product!.imageUrl,
          'about': product!.about,
          'min_age': product!.minAge,
          'max_age': product!.maxAge,
          'url': product!.url,
          'rating': product!.rating,
        },
    };
  }

  WishlistModel copyWith({
    String? id,
    String? userId,
    String? productId,
    DateTime? addedAt,
    bool? isPriority,
    MarketProductModel? product,
  }) {
    return WishlistModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
      isPriority: isPriority ?? this.isPriority,
      product: product ?? this.product,
    );
  }

  // Create a wishlist item from a market product
  factory WishlistModel.fromProduct(String userId, MarketProductModel product) {
    return WishlistModel(
      userId: userId,
      productId: product.id!,
      addedAt: DateTime.now(),
      isPriority: false,
      product: product,
    );
  }

  // Helper method to check if the item is affordable
  bool isAffordable(double balance) {
    return product?.price != null && product!.price <= balance;
  }

  // Get time since added
  String get timeAgo {
    final difference = DateTime.now().difference(addedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
