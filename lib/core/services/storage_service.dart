import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/models/login_response_model.dart';
import '../../features/auth/models/user_model.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyLoginResponse = 'login_response';

  final SharedPreferences _prefs;

  StorageService(this._prefs);


  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_keyToken);
  }


  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_keyUser, userJson);
  }

  UserModel? getUser() {
    final userJson = _prefs.getString(_keyUser);
    if (userJson == null) return null;
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> removeUser() async {
    await _prefs.remove(_keyUser);
  }


  Future<void> saveLoginResponse(LoginResponseModel loginResponse) async {
    await saveToken(loginResponse.token);
    await saveUser(loginResponse.data);
    final loginResponseJson = loginResponse.toJsonString();
    await _prefs.setString(_keyLoginResponse, loginResponseJson);
  }

  LoginResponseModel? getLoginResponse() {
    final loginResponseJson = _prefs.getString(_keyLoginResponse);
    if (loginResponseJson == null) return null;
    try {
      return LoginResponseModel.fromJsonString(loginResponseJson);
    } catch (e) {
      return null;
    }
  }

  Future<void> removeLoginResponse() async {
    await removeToken();
    await removeUser();
    await _prefs.remove(_keyLoginResponse);
  }


  bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }

  Future<void> clearAuthData() async {
    await removeLoginResponse();
  }
}

