import 'dart:io';

import 'package:dio/dio.dart';
import 'package:my_app/configs/Constant.dart';
import 'package:my_app/models/todo.model.dart';
import 'package:my_app/services/dio.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  static Future<List<MTodo>> getTodos() async {
    try {
      final dio = await DioService.getDio();
      final response = await dio.get('$URL_BASE/todo/list');
      if (response.statusCode == STATUS_SUCCESS) {
        final data = response.data;
        return List<MTodo>.from(
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
}
