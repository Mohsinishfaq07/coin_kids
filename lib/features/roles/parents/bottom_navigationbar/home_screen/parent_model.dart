import 'package:cloud_firestore/cloud_firestore.dart';

class ParentModelClass {
  final String? createdAt;
  final String? dob;
  final String? email;
  final String? gender;
  final String? name;
  final String? password;

  ParentModelClass({
    this.createdAt,
    this.dob,
    this.email,
    this.gender,
    this.name,
    this.password,
  });

  /// Factory constructor to parse data from Firestore document
  factory ParentModelClass.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return ParentModelClass(
      createdAt: data?['created_at'] as String?,
      dob: data?['dob'] as String?,
      email: data?['email'] as String?,
      gender: data?['gender'] as String?,
      name: data?['name'] as String?,
      password: data?['password'] as String?,
    );
  }

  /// Convert Parent instance back to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt,
      'dob': dob,
      'email': email,
      'gender': gender,
      'name': name,
      'password': password,
    };
  }
}
