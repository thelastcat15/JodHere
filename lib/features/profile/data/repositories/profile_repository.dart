import 'package:jodhere/core/api/api_client.dart';
import 'package:jodhere/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<ProfileModel> fetchProfile() async {
    final response = await _apiClient.get('/profile');
    return ProfileModel.fromJson(response['data']);
  }

  Future<ProfileModel> updateProfile({
    String? displayName,
    String? phone,
  }) async {
    final body = <String, dynamic>{};

    body['display_name'] = displayName;
    body['phone'] = phone;

    final response = await _apiClient.put('/profile', body: body);

    return ProfileModel.fromJson(response['data']);
  }
}