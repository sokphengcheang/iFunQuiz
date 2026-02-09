import 'package:flutter/material.dart';
import 'package:ifunquiz/splash_screen.dart';
import 'package:ifunquiz/src/core/common/extensions/context_extension.dart';
import 'package:ifunquiz/src/core/constant/localization/localization.dart';
import 'package:ifunquiz/src/feature/game/widget/game_page.dart';
import 'package:ifunquiz/src/feature/settings/model/app_settings.dart';
import 'package:ifunquiz/src/feature/settings/model/app_theme.dart';
import 'package:ifunquiz/src/feature/settings/widget/settings_scope.dart';
import 'package:ifunquiz/src/navigator.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatelessWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  Widget build(BuildContext context) {
    final AppSettings settings = SettingsScope.settingsOf(context);
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    final AppTheme theme = settings.appTheme;
    final ThemeData lightTheme = theme.buildThemeData(ThemeMode.light);
    final ThemeData darkTheme = theme.buildThemeData(ThemeMode.dark);

    final ThemeMode themeMode = theme.themeMode;
    final Locale locale = settings.locale ?? Localization.computeDefaultLocale();

    return MaterialApp(
      navigatorKey: NavigatorKey.key,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      home: const SplashScreen(),
      builder: (context, child) => MediaQuery(
        key: _globalKey,
        data: mediaQueryData.copyWith(
          textScaler: TextScaler.linear(mediaQueryData.textScaler.scale(settings.textScale ?? 1).clamp(0.5, 2)),
        ),
        child: child!,
      ),
    );
  }
}
