/// Authentication Service
/// Handles user authentication, registration, and session management

import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_response.dart';
import '../models/user_model.dart';
import '../constants/user_roles.dart';

class AuthService {
  final _logger = Logger('AuthService');
  final ApiClient _apiClient;
  final SharedPreferences _prefs;

  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;

  AuthService(this._apiClient, this._prefs) {
    _loadSession();
  }

  /// Get current user
  UserModel? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _currentUser != null && _accessToken != null;

  /// Get current access token
  String? get accessToken => _accessToken;

  /// Load session from storage
  Future<void> _loadSession() async {
    try {
      _accessToken = _prefs.getString(ApiConfig.accessTokenKey);
      _refreshToken = _prefs.getString(ApiConfig.refreshTokenKey);

      final userData = _prefs.getString(ApiConfig.userDataKey);
      if (userData != null) {
        _currentUser = UserModel.fromJson(jsonDecode(userData));
      }

      // Set token in API client
      if (_accessToken != null) {
        await _apiClient.setToken(_accessToken!);
      }
    } catch (e) {
      _logger.warning('Error loading session', e);
      await clearSession();
    }
  }

  /// Save session to storage
  Future<void> _saveSession({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _currentUser = user;

    await _prefs.setString(ApiConfig.accessTokenKey, accessToken);
    await _prefs.setString(ApiConfig.refreshTokenKey, refreshToken);
    await _prefs.setString(ApiConfig.userDataKey, jsonEncode(user.toJson()));

    // Set token in API client
    await _apiClient.setToken(accessToken);

    // Set session in Supabase client for storage operations
    try {
      _logger.info('Setting Supabase session with both access and refresh tokens');

      // Fix: Pass both tokens as a combined string (Supabase format)
      // Format: "accessToken.refreshToken"
      await Supabase.instance.client.auth.recoverSession('$accessToken.$refreshToken');

      _logger.info('✅ Supabase session set successfully with both tokens');
    } catch (e) {
      _logger.severe('Failed to set Supabase session', e);
      // Don't throw - session save should continue even if Supabase session fails
    }
  }

  /// Clear session from storage
  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    _currentUser = null;

    await _prefs.remove(ApiConfig.accessTokenKey);
    await _prefs.remove(ApiConfig.refreshTokenKey);
    await _prefs.remove(ApiConfig.userDataKey);
    await _prefs.remove(ApiConfig.userRoleKey);

    // Clear token in API client
    await _apiClient.clearToken();
  }

  /// Register new user
  Future<ApiResponse<UserModel>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required UserRole role,
    String? fullName,
    String? phoneNumber,
  }) async {
    // Password confirmation is validated on frontend, not sent to backend
    if (password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/register',
        data: {
          'email': email,
          'password': password,
          // confirm_password is not sent - backend doesn't expect it
          'role': UserRoleHelper.getRoleName(role),
          'display_name': fullName,
          'phone_number': phoneNumber,
        },
        fromJson: (data) {
          final userData = data['user'];
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];

          final user = UserModel.fromJson(userData);

          // Save session
          _saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: user,
          );

          return user;
        },
      );

      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Login with email and password
  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/login',
        data: {
          'email': email,
          'password': password,
        },
        fromJson: (data) {
          final userData = data['user'];
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];

          final user = UserModel.fromJson(userData);

          // Save session
          _saveSession(
            accessToken: accessToken,
            refreshToken: refreshToken,
            user: user,
          );

          return user;
        },
      );

      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Logout
  Future<ApiResponse<void>> logout() async {
    try {
      // Call backend logout endpoint
      await _apiClient.post('${ApiConfig.auth}/logout');

      // Clear local session
      await clearSession();

      return ApiResponse.success(data: null);
    } catch (e) {
      // Even if API call fails, clear local session
      await clearSession();
      return ApiResponse.success(data: null);
    }
  }

  /// Refresh access token
  Future<ApiResponse<String>> refreshAccessToken() async {
    if (_refreshToken == null) {
      return ApiResponse.error(message: 'No refresh token available');
    }

    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/refresh',
        data: {
          'refresh_token': _refreshToken,
        },
        fromJson: (data) {
          return data['access_token'] as String;
        },
      );

      if (response.success && response.data != null) {
        _accessToken = response.data!;
        await _prefs.setString(ApiConfig.accessTokenKey, _accessToken!);
        await _apiClient.setToken(_accessToken!);
      }

      return response;
    } catch (e) {
      // If refresh fails, clear session
      await clearSession();
      return ApiResponse.error(message: 'Session expired. Please login again.');
    }
  }

  /// Get current user from API
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.auth}/me',
        fromJson: (data) {
          final user = UserModel.fromJson(data);
          _currentUser = user;

          // Update stored user data
          _prefs.setString(ApiConfig.userDataKey, jsonEncode(user.toJson()));

          return user;
        },
      );

      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Update user profile
  Future<ApiResponse<UserModel>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bio,
  }) async {
    try {
      final response = await _apiClient.patch(
        '${ApiConfig.auth}/profile',
        data: {
          if (fullName != null) 'full_name': fullName,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (bio != null) 'bio': bio,
        },
        fromJson: (data) {
          final user = UserModel.fromJson(data);
          _currentUser = user;

          // Update stored user data
          _prefs.setString(ApiConfig.userDataKey, jsonEncode(user.toJson()));

          return user;
        },
      );

      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Change password
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword,
        },
      );

      return ApiResponse.success(data: null);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Request password reset
  Future<ApiResponse<void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _apiClient.post(
        '${ApiConfig.auth}/forgot-password',
        data: {
          'email': email,
        },
      );

      return ApiResponse.success(data: null);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Reset password with token
  Future<ApiResponse<void>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await _apiClient.post(
        '${ApiConfig.auth}/reset-password',
        data: {
          'token': token,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword,
        },
      );

      return ApiResponse.success(data: null);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Switch user role
  Future<ApiResponse<UserModel>> switchRole(UserRole role) async {
    if (_currentUser == null) {
      return ApiResponse.error(message: 'No user logged in');
    }

    if (!_currentUser!.canSwitchTo(role)) {
      return ApiResponse.error(message: 'Cannot switch to this role');
    }

    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/switch-role',
        data: {
          'role': UserRoleHelper.getRoleName(role),
        },
        fromJson: (data) {
          final user = UserModel.fromJson(data['user']);
          final accessToken = data['access_token'];

          _currentUser = user;
          _accessToken = accessToken;

          // Update stored data
          _prefs.setString(ApiConfig.userDataKey, jsonEncode(user.toJson()));
          _prefs.setString(ApiConfig.accessTokenKey, accessToken);
          _apiClient.setToken(accessToken);

          return user;
        },
      );

      return response;
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Verify email with token
  Future<ApiResponse<void>> verifyEmail(String token) async {
    try {
      await _apiClient.post(
        '${ApiConfig.auth}/verify-email',
        data: {
          'token': token,
        },
      );

      // Refresh user data
      await getCurrentUser();

      return ApiResponse.success(data: null);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  /// Resend verification email
  Future<ApiResponse<void>> resendVerificationEmail() async {
    try {
      await _apiClient.post('${ApiConfig.auth}/resend-verification');
      return ApiResponse.success(data: null);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }
}
