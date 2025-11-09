import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/models/login_response_model.dart';
import '../../features/auth/models/user_model.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'user_data';
  static const String _keyLoginResponse = 'login_response';
  static const String _keyLanguageCode = 'language_code';

  final SharedPreferences _prefs;
  final ValueNotifier<UserModel?> userNotifier;
  UserModel? _cachedUser;

  StorageService(this._prefs) : userNotifier = ValueNotifier<UserModel?>(null) {
    _cachedUser = _loadUserFromPrefs();
    userNotifier.value = _cachedUser;
  }

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
    _cachedUser = user;
    userNotifier.value = user;
  }

  Future<void> updateStoredUser(UserModel user) async {
    await saveUser(user);
    final loginResponseJson = _prefs.getString(_keyLoginResponse);
    if (loginResponseJson != null) {
      try {
        final existingResponse = LoginResponseModel.fromJsonString(
          loginResponseJson,
        );
        final updatedResponse = LoginResponseModel(
          result: existingResponse.result,
          data: user,
          message: existingResponse.message,
          status: existingResponse.status,
          token: existingResponse.token,
        );
        await _prefs.setString(
          _keyLoginResponse,
          updatedResponse.toJsonString(),
        );
      } catch (_) {
        // If parsing fails, fall back to saving only the user data.
      }
    }
  }

  UserModel? getUser() {
    return _cachedUser;
  }

  Future<void> removeUser() async {
    await _prefs.remove(_keyUser);
    _cachedUser = null;
    userNotifier.value = null;
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

  Future<void> saveLanguageCode(String code) async {
    await _prefs.setString(_keyLanguageCode, code);
  }

  String? getLanguageCode() {
    return _prefs.getString(_keyLanguageCode);
  }

  bool isLoggedIn() {
    return getToken() != null && getUser() != null;
  }

  UserModel? _loadUserFromPrefs() {
    final userJson = _prefs.getString(_keyUser);
    if (userJson == null) return null;
    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAuthData() async {
    await removeLoginResponse();
  }
}
