class AuthService {
  String? accessToken;

  bool get isLoggedIn => accessToken != null;

  void logout() {
    accessToken = null;
  }

  void setToken(String token) {
    accessToken = token;
  }

  String? getToken() {
    return accessToken;
  }
}

final authService = AuthService();
