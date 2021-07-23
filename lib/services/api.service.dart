import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_app/configs/Constant.dart';
import 'package:my_app/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

var dio = Dio();

class API {
  static Future<MUser> loginService(Object data) async {
    try {
      EasyLoading.show();
      final response = await dio.post('$URL_BASE/login', data: data);
      if (response.statusCode == STATUS_SUCCESS) {
        EasyLoading.dismiss();
        return MUser.fromJson(response.data);
      } else {
        EasyLoading.dismiss();
        throw Exception('Login failed.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      throw Exception('Login failed.');
    }
  }

  static Future<MUser> registerService(Object data) async {
    try {
      EasyLoading.show();
      final response = await dio.post('$URL_BASE/register', data: data);
      if (response.statusCode == STATUS_SUCCESS) {
        EasyLoading.dismiss();
        return MUser.fromJson(response.data);
      } else {
        EasyLoading.dismiss();
        throw Exception('Register failed.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      throw Exception('Register failed.');
    }
  }

  static Future<dynamic> getTodos() async {
    try {
      EasyLoading.show();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await dio.get('$URL_BASE/todo/list',
          options: Options(
              headers: {HttpHeaders.authorizationHeader: 'Bearer $token'}));
      if (response.statusCode == STATUS_SUCCESS) {
        EasyLoading.dismiss();
        return response.data;
      } else {
        EasyLoading.dismiss();
        throw Exception('Register failed.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      throw Exception('Register failed.');
    }
  }

  static Future<dynamic> addTodo(formData) async {
    try {
      EasyLoading.show();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await dio.post(
        '$URL_BASE/todo/add',
        data: formData,
        options: Options(
            headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
            contentType: 'multipart/form-data'),
      );
      if (response.statusCode == STATUS_SUCCESS) {
        EasyLoading.dismiss();
        return response.data;
      } else {
        EasyLoading.dismiss();
        throw Exception('Add todo failed.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      throw Exception('Add todo failed.');
    }
  }
}
