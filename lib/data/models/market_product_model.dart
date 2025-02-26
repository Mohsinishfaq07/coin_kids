class MarketProductModel {
  final String? id; // Optional for new products
  final String name;
  final double price;
  final double rating;
  final int minAge;
  final int maxAge;
  final String imageUrl;
  final String url;
  final List<String> about;

  MarketProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.minAge,
    required this.maxAge,
    required this.imageUrl,
    required this.url,
    required this.about,
  });

  factory MarketProductModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return MarketProductModel(
      id: id,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      minAge: json['min_age'] ?? 0,
      maxAge: json['max_age'] ?? 99,
      imageUrl: json['image_url'] ?? '',
      url: json['url'] ?? '',
      about: List<String>.from(json['about'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'rating': rating,
      'min_age': minAge,
      'max_age': maxAge,
      'image_url': imageUrl,
      'url': url,
      'about': about,
    };
  }

  MarketProductModel copyWith({
    String? id,
    String? name,
    double? price,
    double? rating,
    int? minAge,
    int? maxAge,
    String? imageUrl,
    String? url,
    List<String>? about,
  }) {
    return MarketProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
      about: about ?? this.about,
    );
  }

  // Check if product is suitable for a given age
  bool isSuitableForAge(int age) {
    return age >= minAge && age <= maxAge;
  }

  // Format price with currency symbol
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  // Get rating as stars (e.g., "★★★★½")
  String get ratingStars {
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    String stars = '★' * fullStars;
    if (hasHalfStar) stars += '½';

    return stars;
  }
}
