class ParentModel {
  final String email;
  final String name;
  final String password;
  final String gender;
  final String dob;
  final List<String> kids; // This is a list of kid references (or ids)
  final String createdAt;

  ParentModel({
    required this.email,
    required this.name,
    required this.password,
    required this.gender,
    required this.dob,
    required this.kids,
    required this.createdAt,
  });

  // Convert the model to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'gender': gender,
      'dob': dob,
      'kids': kids,
      'created_at': createdAt,
    };
  }

  // Create an instance of ParentModel from a Map
  factory ParentModel.fromMap(Map<String, dynamic> map) {
    return ParentModel(
      email: map['email'],
      name: map['name'],
      password: map['password'],
      gender: map['gender'],
      dob: map['dob'],
      kids: List<String>.from(map['kids'] ?? []), // handle null kids
      createdAt: map['created_at'],
    );
  }
}
