import 'package:get/get.dart';
import 'package:track_app_flutter/models/tracked_asset.dart';

class AssetController extends GetxController {
  RxList<TrackedAsset> trackedAsset = <TrackedAsset>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void addTrackedAsset(String name, double amount) {
    trackedAsset.add(TrackedAsset(
      name: name,
      amount: amount,
    ));
  }
}
