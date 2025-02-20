import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModel {
  final String email;
  final String password;
  final String name;
  final int pin;
  final DateTime createdAt;
  final DateTime dob;
  final String gender;

  ParentModel({
    required this.email,
    required this.password,
    required this.name,
    required this.pin,
    required this.createdAt,
    required this.dob,
    required this.gender,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      pin: json['pin'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dob: (json['dob'] as Timestamp?)?.toDate() ?? DateTime.now(),
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'pin': pin,
      'createdAt': Timestamp.fromDate(createdAt),
      'dob': Timestamp.fromDate(dob),
      'gender': gender,
    };
  }

  // Create a copy of ParentModel with updated fields
  ParentModel copyWith({
    String? email,
    String? password,
    String? name,
    int? pin,
    List<String>? children,
    DateTime? createdAt,
    DateTime? dob,
    String? gender,
  }) {
    return ParentModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }
} 