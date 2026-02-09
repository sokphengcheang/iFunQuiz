import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:ifunquiz/src/feature/game/widget/game_page.dart';
import 'package:ifunquiz/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _zoomController;
  late final Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _zoomAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeInOut),
    );
    _initialize();
  }

  Future<void> setupRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 5),
        ),
      );
      await remoteConfig.fetchAndActivate().then((value) {
        remoteConfig.setDefaults(<String, dynamic>{
          'weburl': remoteConfig.getString('weburl'),
        });
      });
    } catch (e) {
      // Handle fetch error
    }
  }

  Future<void> _initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    await setupRemoteConfig();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool activated = prefs.getBool('activated') ?? false;
    // final countryIpResponse = await CountryIp.find();
    // final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    // List availablecounties = json.decode(
    //   remoteConfig.getValue("country").asString(),
    // );
    // final first = availablecounties.indexWhere(
    //   (note) => note == countryIpResponse?.country,
    // );
    // inspect(first);
    // if (activated) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LandingPage()),
    //   );
    // } else {
    // await UTIL.initLink();
    // await UTIL.initUniLinksListen();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GamePage()),
      );
    });
    // }

    UTIL.checkUpdateApp();
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF12122b),
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _zoomAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _zoomAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/logo.png',
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
