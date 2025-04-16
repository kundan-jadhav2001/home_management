class User {
  int? id;
  String username;
  String password;
  String email;

  User({this.id, required this.username, required this.password, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
    };
  }
}