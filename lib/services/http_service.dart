import 'package:dio/dio.dart';
import 'package:track_app_flutter/const.dart';

class HTTPService {
  final Dio dio = Dio();

  HTTPService() {
    _configureDio();
  }

  void _configureDio() {
    dio.options = BaseOptions(
      baseUrl: "https://api.cryptorank.io/v1/",
      queryParameters: {
        "api_key": CYRPTO_API_KEY,
      },
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await dio.get(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
