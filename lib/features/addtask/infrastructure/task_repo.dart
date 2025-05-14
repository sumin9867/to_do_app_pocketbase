import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:to_do_app_with_pocketbase/features/addtask/model/task_model.dart';

class TaskRepo {
  final Dio dio;

  TaskRepo(this.dio);

  Future<Either<String, TaskModel>> addTask(TaskModel task) async {
    const String endpoint = '/api/collections/tasks/records';

    try {

      log("i am log  ${task.toJson().toString()}");
      final response = await dio.post(
        endpoint,
        data: task.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final TaskModel newTask = TaskModel.fromJson(response.data);
        return Right(newTask);
      } else {
        return Left('Failed to add task. Status code: ${response.statusCode}');
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

  Future<Either<String, List<TaskModel>>> getAllTasks(String userId) async {
    final String endpoint = '/api/collections/tasks/records';

    try {
      final response = await dio.get(
        endpoint,
      );

      if (response.statusCode == 200) {
        final tasks = (response.data['items'] as List)
            .map((taskJson) => TaskModel.fromJson(taskJson))
            .toList();
        return Right(tasks);
      } else {
        return Left(
            'Failed to fetch tasks. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left('Connection error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, bool>> deleteTask(String taskId) async {
    final String endpoint = '/api/collections/tasks/records/$taskId';

    try {
      final response = await dio.delete(endpoint);

      if (response.statusCode == 200) {
        return Right(true); 
      } else {
        return Left(
            'Failed to delete task. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left('Connection error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, String>> markTaskAsCompleted(String taskId) async {
    final String endpoint = '/api/collections/tasks/records/$taskId';

    
    final Map<String, dynamic> updatedData = {
      'isCompleted': true,
    };

    try {
      final response = await dio.patch(endpoint, data: updatedData);

      if (response.statusCode == 200) {
     
        return Right("Marked As Compelete"); 
      } else {
        return Left(
            'Failed to mark task as completed. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Left('Connection error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }
  Future<Either<String, TaskModel>> editTask(TaskModel updatedTask) async {
  final String endpoint = '/api/collections/tasks/records/${updatedTask.id}';

  try {
    final response = await dio.patch(
      endpoint,
      data: updatedTask.toJson(),
    );

    if (response.statusCode == 200) {
      final TaskModel editedTask = TaskModel.fromJson(response.data);
      return Right(editedTask);
    } else {
      return Left('Failed to edit task. Status code: ${response.statusCode}');
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
  Future<void> updateTaskStatus(String taskId, bool isExpired) async {
        final String endpoint = '/api/collections/tasks/records/$taskId';

    final response = await dio.patch(
      endpoint,

      data: jsonEncode({
        'isExpired': isExpired,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated task status
      print('Task status updated successfully');
    } else {
      throw Exception('Failed to update task status');
    }
  }

}
