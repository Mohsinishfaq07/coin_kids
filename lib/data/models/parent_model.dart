import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModel {
  final String? id;
  final String email;
  final String password;
  final String name;
  final String pin;
  final DateTime createdAt;
  final int dob;
  final String gender;
  final String imageUrl;
  final bool isOpened;

  ParentModel({
    this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.pin,
    required this.createdAt,
    required this.dob,
    required this.gender,
    required this.isOpened,
    this.imageUrl = '',
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      pin: json['pin'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dob: (json['dob']) ?? DateTime.now().millisecondsSinceEpoch,
      gender: json['gender'] ?? '',
      isOpened: json['isOpened'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'pin': pin,
      'createdAt': Timestamp.fromDate(createdAt),
      'dob': dob,
      'gender': gender,
      'isOpened': isOpened,
      'imageUrl': imageUrl,
    };
  }

  // Create a copy of ParentModel with updated fields
  ParentModel copyWith({
    String? email,
    String? password,
    String? name,
    String? pin,
    List<String>? children,
    DateTime? createdAt,
    int? dob,
    bool? isOpened,
    String? gender,
    String? imageUrl,
  }) {
    return ParentModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      isOpened: isOpened ?? this.isOpened,
    );
  }
}
