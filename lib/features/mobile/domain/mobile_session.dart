import '../../auth/domain/authenticated_user.dart';
import 'mobile_project.dart';

class MobileSession {
  const MobileSession({
    required this.user,
    required this.projects,
    required this.isOffline,
    required this.loadedAt,
  });

  final AuthenticatedUser user;
  final List<MobileProject> projects;
  final bool isOffline;
  final DateTime loadedAt;

  String get primaryRole {
    if (user.isGlobalAdmin) return 'ADMIN_BIOME';
    if (projects.isEmpty) return user.roleLabel;
    return projects.first.role;
  }

  MobileSession copyWith({
    AuthenticatedUser? user,
    List<MobileProject>? projects,
    bool? isOffline,
    DateTime? loadedAt,
  }) {
    return MobileSession(
      user: user ?? this.user,
      projects: projects ?? this.projects,
      isOffline: isOffline ?? this.isOffline,
      loadedAt: loadedAt ?? this.loadedAt,
    );
  }

  factory MobileSession.fromJson(
    Map<String, dynamic> json, {
    bool isOffline = false,
  }) {
    final rawUser = json['user'];
    final rawProjects = json['projects'];

    return MobileSession(
      user: AuthenticatedUser.fromJson(
        rawUser is Map
            ? Map<String, dynamic>.from(rawUser)
            : const <String, dynamic>{},
      ),
      projects: rawProjects is List
          ? rawProjects
              .whereType<Map>()
              .map(
                (item) => MobileProject.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const <MobileProject>[],
      isOffline: isOffline,
      loadedAt: DateTime.tryParse(json['loaded_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'projects': projects.map((project) => project.toJson()).toList(),
      'loaded_at': loadedAt.toIso8601String(),
    };
  }
}
