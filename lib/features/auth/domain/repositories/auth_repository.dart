import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<void> register(
    String email,
    String password1,
    String password2,
    String firstName,
    String lastName,
    String uniqueId,
  );
  Future<UserModel> fetchUserDetails(String token);
}
