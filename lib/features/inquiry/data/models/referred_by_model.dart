class ReferredByModel {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final List<String> permissions;

  ReferredByModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.permissions,
  });

  factory ReferredByModel.fromJson(Map<String, dynamic> json) {
    return ReferredByModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}
