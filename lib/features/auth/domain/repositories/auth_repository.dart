import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Map<String, String>> login(String email, String password);
  Future<void> register(
    String email,
    String password1,
    String password2,
    String firstName,
    String lastName,
    String uniqueId,
  );
  Future<UserModel> fetchUserDetails(String token);
  Future<Map<String, String>> refreshToken(String refreshToken);
  Future<bool> verifyToken(String token);
  Future<void> resetPassword(String email);
  Future<void> setPassword(String currentPassword, String newPassword, String token);
}
