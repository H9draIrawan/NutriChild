class User {
  final String id;
  final String username;
  final String email;
  final String password;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password']);
}
