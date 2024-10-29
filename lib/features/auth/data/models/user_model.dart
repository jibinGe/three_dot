class UserModel {
  final int id;
  final String fullName;
  final String mobile;
  final String username;
  final String email;
  final List<String> permissions;

  UserModel({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.username,
    required this.email,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      mobile: json['mobile'],
      username: json['username'],
      email: json['email'],
      permissions: List<String>.from(json['permissions']),
    );
  }
}
