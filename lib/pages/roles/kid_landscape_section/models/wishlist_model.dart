import 'package:cloud_firestore/cloud_firestore.dart';

import '../kid_market/product_model.dart';

class WishlistModel {
  final String id;
  final String kidId;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final bool deleted;
  final DateTime addedAt;

  WishlistModel({
    required this.id,
    required this.kidId,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.deleted,
    required this.addedAt,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] ?? '',
      kidId: json['kidId'] ?? '',
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      deleted: json['deleted'] ?? false,
      addedAt: (json['addedAt'] as Timestamp).toDate(),
    );
  }

  factory WishlistModel.fromProduct(
      String kidId, ProductModel product, String id) {
    return WishlistModel(
      id: id,
      kidId: kidId,
      productId: product.id,
      name: product.name,
      price: product.price,
      imageUrl: product.imageUrl,
      deleted: false,
      addedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kidId': kidId,
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'deleted': deleted,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
