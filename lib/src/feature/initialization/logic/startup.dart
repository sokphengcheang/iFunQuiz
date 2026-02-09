import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ifunquiz/src/core/common/bloc/app_bloc_observer.dart';
import 'package:ifunquiz/src/core/common/bloc/bloc_transformer.dart';
import 'package:ifunquiz/src/core/constant/application_config.dart';
import 'package:ifunquiz/src/feature/initialization/logic/composition_root.dart';
import 'package:ifunquiz/src/feature/initialization/widget/initialization_failed_app.dart';
import 'package:ifunquiz/src/feature/initialization/widget/root_context.dart';
import 'package:logger/logger.dart';

/// Initializes dependencies and runs app
Future<void> startup() async {
  const config = ApplicationConfig();

  final logger = createAppLogger(
    observers: [if (!kReleaseMode) const PrintingLogObserver(logLevel: LogLevel.trace)],
  );

  await runZonedGuarded(() async {
    // Ensure Flutter is initialized
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();

    // Initialize Firebase with error handling
    try {
      await Firebase.initializeApp();
      if (kDebugMode) {
        print('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization error: $e');
        print('Make sure you have:');
        print('1. google-services.json in android/app/');
        print('2. GoogleService-Info.plist in ios/Runner/');
        print('3. Google Services plugin applied in android/build.gradle.kts');
      }
      // Continue app execution even if Firebase fails
      // Remove this if Firebase is required for your app
    }

    // Configure global error interception
    FlutterError.onError = logger.logFlutterError;
    WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

    // Setup bloc observer and transformer
    Bloc.observer = AppBlocObserver(logger);
    Bloc.transformer = SequentialBlocTransformer<Object?>().transform;

    Future<void> composeAndRun() async {
      try {
        final compositionResult = await composeDependencies(config: config, logger: logger);

        runApp(
          RootContext(
            compositionResult: compositionResult,
          ),
        );
      } on Object catch (e, stackTrace) {
        logger.error('Initialization failed', error: e, stackTrace: stackTrace);
        runApp(
          InitializationFailedApp(
            error: e,
            stackTrace: stackTrace,
            onRetryInitialization: composeAndRun,
          ),
        );
      }
    }

    // Launch the application
    await composeAndRun();
  }, logger.logZoneError);
}
