class DeleteProfileModel {
  final bool success;

  DeleteProfileModel({required this.success});

  factory DeleteProfileModel.fromJson(Map<String, dynamic> json) {
    return DeleteProfileModel(success: json['status'] == 200);
  }
}
