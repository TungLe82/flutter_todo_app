import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  static Future<Dio> getDio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    Dio _dio = new Dio();
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
      return handler.next(options); //continue
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onResponse: (response, handler) {
      // Do something with response data
      return handler.next(response); // continue
      // If you want to reject the request with a error message,
      // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    }, onError: (DioError e, handler) {
      // Do something with response error
      // If you want to resolve the request with some custom data，
      // you can resolve a `Response` object eg: return `dio.resolve(response)`.
      if (e.response?.statusCode == 403 || e.response?.statusCode == 401) {
        _dio.interceptors.requestLock.lock();
        _dio.interceptors.responseLock.lock();
        // refresh token
        _dio.interceptors.requestLock.unlock();
        _dio.interceptors.responseLock.unlock();
        return handler.next(e);
      } else {
        return handler.next(e);
      }
    }));
    return _dio;
  }
}
