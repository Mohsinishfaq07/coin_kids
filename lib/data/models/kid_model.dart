import 'package:cloud_firestore/cloud_firestore.dart';

class WalletJar {
  final double balance;
  final String color;

  WalletJar({
    required this.balance,
    required this.color,
  });

  factory WalletJar.fromJson(Map<String, dynamic> json) {
    return WalletJar(
      balance: (json['balance'] ?? 0.0).toDouble(),
      color: json['color'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'color': color,
    };
  }

  WalletJar copyWith({
    double? balance,
    String? color,
  }) {
    return WalletJar(
      balance: balance ?? this.balance,
      color: color ?? this.color,
    );
  }
}

class Wallet {
  final WalletJar savingJar;
  final WalletJar spendingJar;

  Wallet({
    required this.savingJar,
    required this.spendingJar,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      savingJar: WalletJar.fromJson(json['savingJar'] ?? {}),
      spendingJar: WalletJar.fromJson(json['spendingJar'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'savingJar': savingJar.toJson(),
      'spendingJar': spendingJar.toJson(),
    };
  }

  Wallet copyWith({
    WalletJar? savingJar,
    WalletJar? spendingJar,
  }) {
    return Wallet(
      savingJar: savingJar ?? this.savingJar,
      spendingJar: spendingJar ?? this.spendingJar,
    );
  }
}

class KidModel {
  final String name;
  final String email;
  final String password;
  final int age;
  final String grade;
  final String avatar;
  final String parentId;
  final Wallet wallet;
  final double coinKidsBalance;
  final DateTime createdAt;

  KidModel({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.grade,
    required this.avatar,
    required this.parentId,
    required this.wallet,
    required this.coinKidsBalance,
    required this.createdAt,
  });

  factory KidModel.fromJson(Map<String, dynamic> json) {
    return KidModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      age: json['age'] ?? 0,
      grade: json['grade'] ?? '',
      avatar: json['avatar'] ?? '',
      parentId: json['parentId'] ?? '',
      wallet: Wallet.fromJson(json['wallet'] ?? {}),
      coinKidsBalance: (json['coinKidsBalance'] ?? 0.0).toDouble(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'grade': grade,
      'avatar': avatar,
      'parentId': parentId,
      'wallet': wallet.toJson(),
      'coinKidsBalance': coinKidsBalance,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  KidModel copyWith({
    String? name,
    String? email,
    String? password,
    int? age,
    String? grade,
    String? avatar,
    String? parentId,
    Wallet? wallet,
    double? coinKidsBalance,
    DateTime? createdAt,
  }) {
    return KidModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      avatar: avatar ?? this.avatar,
      parentId: parentId ?? this.parentId,
      wallet: wallet ?? this.wallet,
      coinKidsBalance: coinKidsBalance ?? this.coinKidsBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
