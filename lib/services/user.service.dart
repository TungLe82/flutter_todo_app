import 'package:my_app/configs/Constant.dart';
import 'package:my_app/models/user.model.dart';
import 'package:my_app/services/dio.service.dart';

class UserService {
  static Future<MUser> login(Object data) async {
    try {
      final dio = await DioService.getDio();
      final response = await dio.post('$URL_BASE/login', data: data);
      if (response.statusCode == STATUS_SUCCESS) {
        return MUser.fromJson(response.data);
      } else {
        throw Exception('Login failed.');
      }
    } catch (e) {
      throw Exception('Login failed.');
    }
  }

  static Future<MUser> register(Object data) async {
    try {
      final dio = await DioService.getDio();
      final response = await dio.post('$URL_BASE/register', data: data);
      if (response.statusCode == STATUS_SUCCESS) {
        return MUser.fromJson(response.data);
      } else {
        throw Exception('Register failed.');
      }
    } catch (e) {
      throw Exception('Register failed.');
    }
  }
}
