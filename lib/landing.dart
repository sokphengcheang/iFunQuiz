// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ifunquiz/floating_dial/drag_speed_dail.dart';
import 'package:ifunquiz/src/core/resources/colors.dart';
import 'package:ifunquiz/util.dart';

import 'package:url_launcher/url_launcher_string.dart';

// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with AutomaticKeepAliveClientMixin {
  // late final WebViewController _controller;
  DragSpeedDialChildrenAlignment alignment = DragSpeedDialChildrenAlignment.horizontal;
  DragSpeedDialPosition initialPosition = DragSpeedDialPosition.bottomRight;
  bool isLoading = false;
  ValueNotifier<int> loadProgress = ValueNotifier(0);
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  HeadlessInAppWebView? headlessWebView;
  InAppWebViewController? webViewController;
  String backUrl = "";
  String baseUrl = "";
  String error = "";
  int progress = 0;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    UTIL.postFrame(() async {
      backUrl = remoteConfig.getString('weburl');
      baseUrl = remoteConfig.getString('weburl');
      headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(remoteConfig.getString('weburl')),
        ),
        initialSettings: InAppWebViewSettings(
          useHybridComposition: true,
          allowsInlineMediaPlayback: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
      );
      if (headlessWebView != null && !headlessWebView!.isRunning()) {
        await headlessWebView!.run();
      }
      setState(() {
        isLoaded = true;
      });
    }, mounted);
  }

  void updateBaseUrl(String url) {
    bool isTrue = url.contains(remoteConfig.getString('weburl'));
    bool isTrue2 = url.contains(remoteConfig.getString('weburl_d'));

    if (isTrue) {
      baseUrl = remoteConfig.getString('weburl');
    } else if (isTrue2) {
      baseUrl = remoteConfig.getString('weburl_d');
    }

    setState(() {});
  }

  Future<NavigationActionPolicy> _shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction shouldOverrideUrlLoadingRequest,
  ) async {
    var uri = shouldOverrideUrlLoadingRequest.request.url;
    if (uri == null) {
      // controller.goBack();
      return NavigationActionPolicy.CANCEL;
    }
    final uriString = uri.toString();
    if (uriString.startsWith('http://') || uriString.startsWith('https://')) {
      return NavigationActionPolicy.ALLOW;
    } else {
      // controller.goBack();
      _launchURL(uriString);
      return NavigationActionPolicy.ALLOW;
    }
  }

  Future<bool> _launchURL(String uri) async {
    return await launchUrlString(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).viewPadding;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: Colors.red,
              child: Text(
                error,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                maxLines: 10,
              ),
            ),
            Column(
              children: [
                Container(height: padding.top, color: AppColors.secondary100),
                Visibility(
                  visible: isLoading,
                  child: ValueListenableBuilder<int>(
                    valueListenable: loadProgress,
                    builder: (context, int v, s) {
                      return LinearProgressIndicator(
                        value: v / 100,
                        backgroundColor: AppColors.gray100,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
                if (isLoaded)
                  Expanded(
                    child: InAppWebView(
                      // gestureRecognizers: Set()
                      //   ..add(
                      //     Factory<DragGestureRecognizer>(
                      //       () => VerticalDragGestureRecognizer(),
                      //     ),
                      //   ),
                      headlessWebView: headlessWebView,
                      onLoadStart: (controller, url) async {
                        setState(() {
                          isLoading = true;
                        });
                      },
                      onProgressChanged: (controller, progress) {
                        loadProgress.value = progress;
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      shouldOverrideUrlLoading: _shouldOverrideUrlLoading,
                      onUpdateVisitedHistory: (controller, url, androidIsReload) {
                        updateBaseUrl(url.toString());
                        bool isFrom = url.toString().contains('from=');
                        final rawUrl = remoteConfig.getString(
                          'weburl_lobby',
                        );
                        final rawUrlMobile = remoteConfig.getString(
                          'weburl_lobby_m',
                        );
                        List list = url.toString().split(rawUrl);
                        List listM = url.toString().split(rawUrlMobile);
                        bool isSetBackUrl = (list.length == 2 || listM.length == 2);
                        if (url!.rawValue.contains(baseUrl) && isSetBackUrl && !isFrom) {
                          backUrl = url.rawValue;
                        }
                      },
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
            DragSpeedDial(
              isDraggable: true,
              alignment: alignment,
              initialPosition: initialPosition,
              snagOnScreen: true,
              offsetPosition: Offset(size.width * 0.8, size.height * 0.85),
              fabBgColor: AppColors.secondary100,
              fabIcon: Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset('assets/images/app_logo.png', width: 40),
                ),
              ),
              tooltipMessage: null,
              actionOnPress: null,
              dragSpeedDialChildren: [
                DragSpeedDialChild(
                  onPressed: () {
                    webViewController!.loadUrl(
                      urlRequest: URLRequest(url: WebUri(baseUrl)),
                    );
                  },
                  bgColor: AppColors.secondary100,
                  icon: const Icon(Icons.home_rounded, color: AppColors.gray20),
                ),
                DragSpeedDialChild(
                  onPressed: () {
                    try {
                      String weburl = remoteConfig.getString('weburl');
                      String weburlD = remoteConfig.getString('weburl_d');
                      var depositUrl = "";
                      if (baseUrl.contains(weburl)) {
                        depositUrl = '$baseUrl/index.php?page=center_deposit';
                      } else if (baseUrl.contains(weburlD)) {
                        depositUrl = '$baseUrl/index.php?page=deposit';
                      }
                      setState(() {
                        error = depositUrl;
                      });
                      webViewController!.loadUrl(
                        urlRequest: URLRequest(url: WebUri(depositUrl)),
                      );
                    } catch (e) {
                      setState(() {
                        error = e.toString();
                      });
                    }
                  },
                  bgColor: AppColors.secondary100,
                  icon: const Icon(
                    Icons.add_card_rounded,
                    color: AppColors.gray20,
                  ),
                ),
                // DragSpeedDialChild(
                //   onPressed: () async {
                //     final current = await webViewController!.getUrl();
                //     final canGoback = await webViewController!.canGoBack();
                //     // webViewController!.goBack();

                //     return;
                //     if (current!.rawValue.contains(baseUrl)) {
                //       if (canGoback) {
                //         webViewController!.goBack();
                //       } else {
                //         webViewController!.loadUrl(
                //           urlRequest: URLRequest(
                //             url: WebUri(current.rawValue),
                //           ),
                //         );
                //       }
                //     } else {
                //       webViewController!.loadUrl(
                //         urlRequest: URLRequest(
                //           url: WebUri(backUrl),
                //         ),
                //       );
                //     }
                //   },
                //   bgColor: AppColors.secondary100,
                //   icon: const Icon(
                //     Icons.reply_rounded,
                //     color: AppColors.gray20,
                //     // size: 18,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
