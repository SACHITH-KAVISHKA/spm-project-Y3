class User {
  final String id;
  final String name;
  final int phone;
  final String email;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
    );
  }
}
