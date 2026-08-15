import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

class TokenHelper {
  static final AuthRepository _authRepository = AuthRepositoryImpl();

  static Future<String?> getValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final refresh = prefs.getString('refreshToken');

    if (token == null) return null;

    try {
      final isValid = await _authRepository.verifyToken(token);
      if (isValid) {
        return token;
      }
    } catch (_) {
      // If verification network call fails, proceed to refresh to be safe
    }

    if (refresh != null) {
      try {
        final tokenData = await _authRepository.refreshToken(refresh);
        token = tokenData['access'];
        final newRefresh = tokenData['refresh'];
        
        if (token != null) {
          await prefs.setString('token', token);
        }
        if (newRefresh != null) {
          await prefs.setString('refreshToken', newRefresh);
        }
        return token;
      } catch (_) {
        // If refresh fails, clear tokens to force logging in again
        await prefs.remove('token');
        await prefs.remove('refreshToken');
        return null;
      }
    }

    return null;
  }
}
