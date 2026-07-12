class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isGlobalAdmin,
    required this.active,
    required this.roleLabel,
  });

  final String id;
  final String name;
  final String email;
  final bool isGlobalAdmin;
  final bool active;
  final String roleLabel;

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isGlobalAdmin: json['is_global_admin'] == true,
      active: json['active'] == true,
      roleLabel: json['role_label']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'is_global_admin': isGlobalAdmin,
      'active': active,
      'role_label': roleLabel,
    };
  }
}
