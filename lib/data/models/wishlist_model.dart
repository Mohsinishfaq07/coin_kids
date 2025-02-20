import 'package:cloud_firestore/cloud_firestore.dart';
import 'market_product_model.dart';

class WishlistModel {
  final String? id;
  final String kidId;
  final String productId;
  final DateTime addedAt;
  final bool isPriority;
  final MarketProductModel? product; // Optional cached product data

  WishlistModel({
    this.id,
    required this.kidId,
    required this.productId,
    required this.addedAt,
    this.isPriority = false,
    this.product,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json, {String? id, MarketProductModel? product}) {
    return WishlistModel(
      id: id,
      kidId: json['kidId'] ?? '',
      productId: json['productId'] ?? '',
      addedAt: (json['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPriority: json['isPriority'] ?? false,
      product: product ?? (json['product'] != null 
          ? MarketProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kidId': kidId,
      'productId': productId,
      'addedAt': Timestamp.fromDate(addedAt),
      'isPriority': isPriority,
      // Only store minimal product data if available
      if (product != null)
        'product': {
          'name': product!.name,
          'price': product!.price,
          'image_url': product!.imageUrl,
        },
    };
  }

  WishlistModel copyWith({
    String? id,
    String? kidId,
    String? productId,
    DateTime? addedAt,
    bool? isPriority,
    MarketProductModel? product,
  }) {
    return WishlistModel(
      id: id ?? this.id,
      kidId: kidId ?? this.kidId,
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
      isPriority: isPriority ?? this.isPriority,
      product: product ?? this.product,
    );
  }

  // Create a wishlist item from a market product
  factory WishlistModel.fromProduct(String kidId, MarketProductModel product) {
    return WishlistModel(
      kidId: kidId,
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
