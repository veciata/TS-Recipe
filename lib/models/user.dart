class User {
  final String id;
  final String email;
  final String name;
  final String? username;
  final String role;
  final String? token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.username,
    this.role = 'user',
    this.token,
  });

  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['id'] ?? json['user_id'] ?? '').toString(),
        email: json['email'] as String? ?? '',
        name: (json['name'] ??
                json['username'] ??
                json['email'] ??
                '')
            .toString(),
        username: json['username'] as String?,
        role: json['role'] as String? ?? 'user',
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        if (username != null) 'username': username,
        'role': role,
        if (token != null) 'token': token,
      };
}
