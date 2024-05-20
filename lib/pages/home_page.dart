import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_app_flutter/controllers/asset_controller.dart';
import 'package:track_app_flutter/models/tracked_asset.dart';
import 'package:track_app_flutter/pages/details_page.dart';
import 'package:track_app_flutter/utils.dart';
import 'package:track_app_flutter/widgets/add_asset_dialog.dart';

class HomePage extends StatelessWidget {
  AssetController assetController = Get.find();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(
        context,
      ),
      body: _buildUI(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const CircleAvatar(
        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.dialog(
                AddAssetDialog(),
              );
            },
            icon: const Icon(Icons.add))
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            _portfolioValue(
              context,
            ),
            _trackedAssetList(context),
          ],
        ),
      ),
    );
  }

  Widget _portfolioValue(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.03,
      ),
      child: Center(
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              const TextSpan(
                text: "\$",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                  text:
                      "${assetController.getPortfolioValue().toStringAsFixed(2)}\n",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w400)),
              const TextSpan(
                text: "Portfolio Value",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trackedAssetList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.sizeOf(context).width * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
            child: const Text(
              "My Portfolio",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.65,
            width: MediaQuery.sizeOf(context).width,
            child: ListView.builder(
                itemCount: assetController.trackedAsset.length,
                itemBuilder: (context, index) {
                  TrackedAsset trackedAsset =
                      assetController.trackedAsset[index];
                  return ListTile(
                    leading:
                        Image.network(getCryptoImageURL(trackedAsset.name!)),
                    title: Text(trackedAsset.name!),
                    subtitle: Text(
                        "USDT: ${assetController.getAssetPrice(trackedAsset.name!).toStringAsFixed(2)}"),
                    trailing: Text(
                      trackedAsset.amount.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () {
                      Get.to(() {
                        return DetailsPage(
                          coin:
                              assetController.getCoinData(trackedAsset.name!)!,
                        );
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
