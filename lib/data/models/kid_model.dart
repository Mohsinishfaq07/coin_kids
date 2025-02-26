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
  final String kidId;
  final String name;
  final int age;
  final String avatar;
  final String parentId;
  final Wallet wallet;
  final double coinKidsBalance;
  final DateTime createdAt;

  KidModel({
    required this.kidId,
    required this.name,
    required this.age,
    required this.avatar,
    required this.parentId,
    required this.wallet,
    required this.coinKidsBalance,
    required this.createdAt,
  });

  factory KidModel.fromJson(Map<String, dynamic> json,
      {String documentId = ''}) {
    return KidModel(
      kidId: documentId,
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      avatar: json['avatar'] ?? '',
      parentId: json['parentId'] ?? '',
      wallet: Wallet.fromJson(json['wallet'] ?? {}),
      coinKidsBalance: (json['coinKidsBalance'] ?? 0.0).toDouble(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kidId': kidId,
      'name': name,
      'age': age,
      'avatar': avatar,
      'parentId': parentId,
      'wallet': wallet.toJson(),
      'coinKidsBalance': coinKidsBalance,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  KidModel copyWith({
    String? kidId,
    String? name,
    int? age,
    String? avatar,
    String? parentId,
    Wallet? wallet,
    double? coinKidsBalance,
    DateTime? createdAt,
  }) {
    return KidModel(
      kidId: kidId ?? this.kidId,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      parentId: parentId ?? this.parentId,
      wallet: wallet ?? this.wallet,
      coinKidsBalance: coinKidsBalance ?? this.coinKidsBalance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
