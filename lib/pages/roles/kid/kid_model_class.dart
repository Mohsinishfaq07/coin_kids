class KidModelClass {
  String age;
  String avatar;
  String email;
  String grade;
  String name;
  String parent; // Reference to the parent's document
  String parentId;
  String password;
  Savings savings;
  Spendings spendings;

  KidModelClass({
    required this.age,
    required this.avatar,
    required this.email,
    required this.grade,
    required this.name,
    required this.parent,
    required this.parentId,
    required this.password,
    required this.savings,
    required this.spendings,
  });

  // Factory constructor to create a KidModel instance from a Firestore document
  factory KidModelClass.fromMap(Map<String, dynamic> data) {
    return KidModelClass(
      age: data['age'] ?? '',
      avatar: data['avatar'] ?? '',
      email: data['email'] ?? '',
      grade: data['grade'] ?? '',
      name: data['name'] ?? '',
      parent: data['parent'] ?? '',
      parentId: data['parentId'] ?? '',
      password: data['password'] ?? '',
      savings: Savings.fromMap(data['savings'] ?? {}),
      spendings: Spendings.fromMap(data['spendings'] ?? {}),
    );
  }

  // Method to convert KidModel instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'avatar': avatar,
      'email': email,
      'grade': grade,
      'name': name,
      'parent': parent,
      'parentId': parentId,
      'password': password,
      'savings': savings.toMap(),
      'spendings': spendings.toMap(),
    };
  }
}

class Savings {
  String amount;
  String color;
  String name;

  Savings({
    required this.amount,
    required this.color,
    required this.name,
  });

  factory Savings.fromMap(Map<String, dynamic> data) {
    return Savings(
      amount: data['amount'] ?? '',
      color: data['color'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'color': color,
      'name': name,
    };
  }
}

class Spendings {
  int amount;
  String color;
  String name;

  Spendings({
    required this.amount,
    required this.color,
    required this.name,
  });

  factory Spendings.fromMap(Map<String, dynamic> data) {
    return Spendings(
      amount: data['amount'] ?? 0,
      color: data['color'] ?? '',
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'color': color,
      'name': name,
    };
  }
}
