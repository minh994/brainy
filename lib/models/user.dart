class User {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photo_url': photoUrl,
    };
  }
} 