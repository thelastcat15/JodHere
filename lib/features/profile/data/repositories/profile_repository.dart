import 'package:jodhere/core/api/api_client.dart';
import 'package:jodhere/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository(this.apiClient);

  Future<ProfileModel> getProfile() async {
    final data = await apiClient.get("/profile");
    return ProfileModel.fromJson(data);
  }
}