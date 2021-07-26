import 'package:get/state_manager.dart';
import 'package:my_app/configs/Constant.dart';
import 'package:my_app/models/todo.model.dart';
import 'package:my_app/services/dio.service.dart';

class TodoService {
  static Future<RxList<MTodo>> getTodos() async {
    try {
      final dio = await DioService.getDio();
      final response = await dio.get('$URL_BASE/todo/list');
      if (response.statusCode == STATUS_SUCCESS) {
        final data = response.data;
        return RxList<MTodo>.from(
            data["data"].map((todo) => MTodo.fromJson(todo)));
      } else {
        throw Exception('Get todos failed.');
      }
    } catch (e) {
      throw Exception('Get todos failed.');
    }
  }

  static Future<dynamic> addTodo(formData) async {
    try {
      final dio = await DioService.getDio();
      final response = await dio.post(
        '$URL_BASE/todo/add',
        data: formData,
      );
      if (response.statusCode == STATUS_SUCCESS) {
        return response.data;
      } else {
        throw Exception('Add todo failed.');
      }
    } catch (e) {
      throw Exception('Add todo failed.');
    }
  }

  static Future<dynamic> deleteTodo(id) async {
    try {
      final dio = await DioService.getDio();
      final response = await dio.delete(('$URL_BASE/todo/$id'));
      if (response.statusCode == STATUS_SUCCESS) {
        return response.data;
      } else {
        throw Exception('Delete todo failed.');
      }
    } catch (e) {
      throw Exception('Delete todo failed.');
    }
  }

  static Future<dynamic> updateStatus(Object data) async {
    try {
      final dio = await DioService.getDio();
      final response =
          await dio.put(('$URL_BASE/todo/update-status'), data: data);
      if (response.statusCode == STATUS_SUCCESS) {
        return response.data;
      } else {
        throw Exception('Update status failed.');
      }
    } catch (e) {
      throw Exception('Update status failed.');
    }
  }
}
