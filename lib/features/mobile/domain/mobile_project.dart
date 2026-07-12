class MobileProject {
  const MobileProject({
    required this.id,
    required this.name,
    required this.municipality,
    required this.state,
    required this.neighborhood,
    required this.reurbType,
    required this.status,
    required this.role,
    required this.permissions,
  });

  final String id;
  final String name;
  final String municipality;
  final String state;
  final String neighborhood;
  final String reurbType;
  final String status;
  final String role;
  final List<String> permissions;

  bool hasPermission(String permission) {
    return permissions.contains('*') || permissions.contains(permission);
  }

  factory MobileProject.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permissions'];

    return MobileProject(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      municipality: json['municipality']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      neighborhood: json['neighborhood']?.toString() ?? '',
      reurbType: json['reurb_type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      permissions: rawPermissions is List
          ? rawPermissions.map((item) => item.toString()).toList()
          : const <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'municipality': municipality,
      'state': state,
      'neighborhood': neighborhood,
      'reurb_type': reurbType,
      'status': status,
      'role': role,
      'permissions': permissions,
    };
  }
}
