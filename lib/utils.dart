import 'package:get/get.dart';
import 'package:track_app_flutter/controllers/asset_controller.dart';
import 'package:track_app_flutter/services/http_service.dart';

Future<void> registerService() async {
  Get.put(HTTPService());
}

Future<void> registerControllers() async {
  Get.put(AssetController());
}

String getCryptoImageURL(String name) {
  return "https://raw.githubusercontent.com/ErikThiart/cryptocurrency-icons/master/128/${name.toLowerCase()}.png";
}
