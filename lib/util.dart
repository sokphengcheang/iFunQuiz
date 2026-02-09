// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ifunquiz/ip_package/country_ip_impl.dart';
import 'package:ifunquiz/landing.dart';
import 'package:ifunquiz/src/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

final appLinks = AppLinks();

class UTIL {
  static void postFrame(void Function() callback, bool mounted) => WidgetsBinding.instance.addPostFrameCallback((_) {
        // Execute callback if page is mounted
        if (mounted) callback();
      });

  static Future<void> initLink() async {
    await appLinks.getInitialLink().then((value) async {
      if (value != null) {
        final BuildContext context = NavigatorKey.key.currentContext!;
        await handleDeepLinklisten(context: context);
      }
    });
  }

  static Future<void> initUniLinksListen() async {
    try {
      //   await Future.delayed(const Duration(seconds: 2), () async {
      //     final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks
      //         .instance
      //         .getInitialLink();
      appLinks.uriLinkStream.listen((deepLinkData) async {
        final BuildContext context = NavigatorKey.key.currentContext!;
        await handleDeepLinklisten(context: context);
        // }
      }).onError((error) {
        log('onLink error:');
        log(error.toString());
      });
      // });
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> handleDeepLinklisten({
    required BuildContext context,
  }) async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final countryIpResponse = await CountryIp.find();
    final List<dynamic> availableCountries = json.decode(
      remoteConfig.getValue("country").asString(),
    ) as List<dynamic>;
    final first = availableCountries.indexWhere(
      (note) => note == countryIpResponse?.country,
    );
    if (first >= 0) {
      await sharedPreferences.setBool('activated', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    }
  }

  static int? getLocalVersion() {
    int? version = 1;
    if (Platform.isAndroid) {
      version = int.tryParse(dotenv.env['androidVersion']!);
    } else if (Platform.isIOS) {
      version = int.tryParse(dotenv.env['iosVersion']!);
    }
    return version;
  }

  static checkUpdateApp() async {
    final BuildContext context = NavigatorKey.key.currentContext!;
    final localVersion = getLocalVersion() ?? 1;
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

    final iosLink = remoteConfig.getString('ios_link');
    final iosVersion = remoteConfig.getInt('ios_version');

    // final androidVersion = remoteConfig.getInt('android_version');
    // final androidLink = remoteConfig.getString('android_link');

    if (localVersion < iosVersion) {
      return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('New version available'),
          content: const Text(
            'There are new features available,\n please update your app.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Update'),
              onPressed: () async {
                await launchUrlString(
                  iosLink,
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
          ],
        ),
      );
    }
  }

  static double getResponsiveTextSize(BuildContext context, double size) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 360) {
      // 360
      return size * scaleFactor * 0.8; // smaller screen
    } else if (screenWidth < 600) {
      return size * scaleFactor * 0.9; // medium screen
    }
    return size * scaleFactor; // larger screen or default
  }

  // Responsive Size
  static double getResponsiveSize(BuildContext context, double size) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return size * 0.8;
    } else if (screenWidth < 600) {
      return size * 0.9;
    }
    return size;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
