import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id; // This will be the document ID
  final String name;
  final List<dynamic> description;
  final double price;
  final double rating;
  final String imageUrl;
  final int minAge;
  final int maxAge;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.minAge,
    required this.maxAge,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id, // Use document ID here
      name: data['name'] ?? '',
      description: data['about'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      imageUrl: data['image_url'] ?? '',
      minAge: data['min_age'] ?? 0,
      maxAge: data['max_age'] ?? 18,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': description,
      'price': price,
      'rating': rating,
      'image_url': imageUrl,
      'min_age': minAge,
      'max_age': maxAge,
    };
  }
}
