import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:track_app_flutter/controllers/asset_controller.dart';
import 'package:track_app_flutter/models/api_response.dart';
import 'package:track_app_flutter/services/http_service.dart';

class AddAssetDialogController extends GetxController {
  RxBool loading = false.obs;
  RxList<String> assets = <String>[].obs;
  RxString selectedAsset = "".obs;
  RxDouble assetValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _getAssets();
  }

  Future<void> _getAssets() async {
    loading.value = true;
    HTTPService httpService = Get.find();
    var responseData = await httpService.get("currencies");
    CurrenciesListAPIResponse currenciesListAPIResponse =
        CurrenciesListAPIResponse.fromJson(responseData);
    currenciesListAPIResponse.data?.forEach(
      (coin) {
        assets.add(
          coin.name!,
        );
      },
    );
    selectedAsset.value = assets.first;
    loading.value = false;
  }
}

class AddAssetDialog extends StatelessWidget {
  final controller = Get.put(
    AddAssetDialogController(),
  );

  AddAssetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: Material(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.40,
            width: MediaQuery.sizeOf(context).width * 0.80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: _buildUI(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    if (controller.loading.isTrue) {
      return const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton(
              value: controller.selectedAsset.value,
              items: controller.assets.map(
                (asset) {
                  return DropdownMenuItem(
                    value: asset,
                    child: Text(
                      asset,
                    ),
                  );
                },
              ).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedAsset.value = value;
                }
              },
            ),
            TextField(
              onChanged: (value) {
                controller.assetValue.value = double.parse(value);
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            MaterialButton(
              onPressed: () {
                AssetController assetController = Get.find();
                assetController.addTrackedAsset(controller.selectedAsset.value,
                    controller.assetValue.value);
                Get.back(closeOverlays: true);
              },
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                "Add Asset",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );
    }
  }
}
