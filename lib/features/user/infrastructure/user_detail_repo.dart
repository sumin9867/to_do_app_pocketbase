import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:to_do_app_with_pocketbase/features/auth/model/user_model.dart';

class UserDetailRepo {
  final Dio dio;

  UserDetailRepo(this.dio);

  Future<Either<String, UserModel>> getUserInfo(String userId) async {
    final String endpoint = '/api/collections/users/records/$userId';

    try {
      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final user = UserModel.fromJson(data);
        return Right(user);
      } else {
        return Left(
            'Failed to fetch user data. Status Code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorMessage =
            e.response?.data['message'] ?? 'Unknown server error';
        return Left('Server error: $errorMessage');
      } else {
        return Left('Connection error: ${e.message}');
      }
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }
}
