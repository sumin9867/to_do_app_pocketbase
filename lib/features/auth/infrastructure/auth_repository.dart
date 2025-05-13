import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:to_do_app_with_pocketbase/features/auth/infrastructure/auth_local_storage.dart';
import 'package:to_do_app_with_pocketbase/features/auth/model/user_model.dart';

class AuthRepository {
  final Dio dio;
  final AuthLocalStorage tokenStorage;

  AuthRepository(this.dio, this.tokenStorage);

  Future<Either<String, Map<String, dynamic>>> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await dio.post(
        "/api/collections/users/records",
        data: {
          "email": email,
          "password": password,
          "passwordConfirm": password,
          "name": name,
        },
      );

      return await _loginUser(email, password);
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      return left("Registration/Login failed: $message");
    } catch (e) {
      return left("Unexpected error: $e");
    }
  }

  Future<Either<String, Map<String, dynamic>>> loginUser({
    required String email,
    required String password,
  }) async {
    return await _loginUser(email, password);
  }

  Future<Either<String, Map<String, dynamic>>> _loginUser(
    String email,
    String password,
  ) async {
    try {
      final loginResponse = await dio.post(
        "/api/collections/users/auth-with-password",
        data: {
          "identity": email,
          "password": password,
        },
      );

      final token = loginResponse.data['token'];
      final user = UserModel.fromJson(loginResponse.data['record']);
      final userId = user.id;  // Get the user ID from the model

      // Save token and user ID in local storage
      await tokenStorage.saveToken(token);
      await tokenStorage.saveUserId(userId);  // Save the user ID

      return Right({
        'token': token,
        'user': user,
        'userId': userId,  // Return the user ID along with the token and user data
      });
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      return Left("Login failed: $message");
    } catch (e) {
      return Left("Unexpected error: $e");
    }
  }
}
