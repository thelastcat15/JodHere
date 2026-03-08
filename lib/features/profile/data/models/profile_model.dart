class ProfileModel {
  final String id;
  final String displayName;
  final String email;
  final String? phone;

  ProfileModel({
    required this.id,
    required this.displayName,
    required this.email,
    this.phone,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['uid'],
      displayName: json['display_name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
