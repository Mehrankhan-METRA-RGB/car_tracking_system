import 'package:car_tracking_system/MVC/Views/admin/security/map_security.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class DynamicLinks {
  static Future<String> createDynamicLink(bool short, String token) async {
    DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://cartrackingsystem.page.link',
      link: Uri.parse(
          'https://cartrackingsystem.page.link/rider-live-map?token=$token'),
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
      bool? isProduct = deepLink?.pathSegments.contains('rider-live-map');
      if (isProduct!) {
        String? token = deepLink?.queryParameters['token'];

        // TODO : Navigate to your pages accordingly here

        try {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SecurityMap(
                        companyId: token?.split('%')[0],
                        driverId: token?.split('%')[1],
                        isDynamicLink: true,
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

  static void shareLink(
      BuildContext context, String message, String subject) async {}
}
