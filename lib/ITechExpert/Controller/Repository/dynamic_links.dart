import 'package:car_tracking_system/ITechExpert/Data/data.dart';
import 'package:car_tracking_system/ITechExpert/Views/product_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import '../../Model/item_model.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class DynamicLinks {
  static Future<String> createDynamicLink(bool short, Item item) async {
    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cartrackingsystem.page.link',
      link: Uri.parse(
          'https://cartrackingsystem.page.link/product?id=${item.id.toString()}'),
      androidParameters: const AndroidParameters(
        packageName: 'com.metra.cartrackingsystem.car_tracking_system',
        minimumVersion: 1,
      ),
    );

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    Uri url = shortLink.shortUrl;

    print(url.toString());
    return url.toString();
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    try {
      final Uri? deepLink = data?.link;
      bool? isProduct = deepLink?.pathSegments.contains('product');
      if (isProduct!) {
        String? id = deepLink?.queryParameters['id'];
        print('IDDDDDDDDD: $id');
        // TODO : Navigate to your pages accordingly here

        try {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(
                        item: items.firstWhere((e) => e.id.toString() == id),
                      )));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static void shareLink(BuildContext context, String message, String subject) async{
  }
}
