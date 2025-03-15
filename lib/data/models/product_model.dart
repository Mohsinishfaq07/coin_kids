class ProductModel {
  final String name;
  final List<String> about;
  final int maxAge;
  final int minAge;
  final String imageUrl;
  final double price;
  final int rating;
  final String url;

  ProductModel({
    required this.name,
    required this.about,
    required this.maxAge,
    required this.minAge,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      about: List<String>.from(json['about'] ?? []),
      maxAge: json['max_age']?.toInt() ?? 0,
      minAge: json['min_age']?.toInt() ?? 0,
      imageUrl: json['image_url'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: json['rating']?.toInt() ?? 0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'about': about,
      'max_age': maxAge,
      'min_age': minAge,
      'image_url': imageUrl,
      'price': price,
      'rating': rating,
      'url': url,
    };
  }
}
