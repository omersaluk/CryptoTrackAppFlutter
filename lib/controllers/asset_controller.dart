import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_app_flutter/models/api_response.dart';
import 'package:track_app_flutter/models/coin_data.dart';
import 'package:track_app_flutter/models/tracked_asset.dart';
import 'package:track_app_flutter/services/http_service.dart';

class AssetController extends GetxController {
  RxList<CoinData> coinData = <CoinData>[].obs;
  RxBool loading = false.obs;
  RxList<TrackedAsset> trackedAsset = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getAsset();
    _loadTrackedAssetsFromStorage();
  }

  Future<void> _getAsset() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    coinData.value = currenciesListAPIResponse.data ?? [];
    loading.value = false;
  }

  void addTrackedAsset(String name, double amount) async {
    trackedAsset.add(TrackedAsset(
      name: name,
      amount: amount,
    ));

    List<String> data = trackedAsset.map((asset) => jsonEncode(asset)).toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("tracked_asset", data);
  }

  void _loadTrackedAssetsFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList("tracked_asset");
    if (data != null) {
      trackedAsset.value =
          data.map((e) => TrackedAsset.fromJson(jsonDecode(e))).toList();
    }
  }

  double getPortfolioValue() {
    if (trackedAsset.isEmpty) {
      return 0;
    }
    if (coinData.isEmpty) {
      return 0;
    }
    double value = 0;
    for (TrackedAsset asset in trackedAsset) {
      value += getAssetPrice(asset.name!) * asset.amount!;
    }
    return value;
  }

  double getAssetPrice(String name) {
    CoinData? data = getCoinData(name);
    return data?.values?.uSD?.price?.toDouble() ?? 0;
  }

  CoinData? getCoinData(String name) {
    return coinData.firstWhereOrNull((e) => e.name == name);
  }
}
