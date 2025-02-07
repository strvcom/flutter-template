import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_remote_config_service.g.dart';

@Riverpod(keepAlive: true)
class FirebaseRemoteConfigService extends _$FirebaseRemoteConfigService {
  final firebaseRemoteConfig = FirebaseRemoteConfig.instance;

  @override
  FutureOr<FirebaseRemoteConfigService> build() async {
    try {
      await firebaseRemoteConfig.ensureInitialized();
      await firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await firebaseRemoteConfig.fetchAndActivate();
    } on FirebaseException catch (e, st) {
      Flogger.e('Unable to initialize Firebase Remote Config', exception: e, stackTrace: st);
    }

    return this;
  }

  int getMinSupportedBuildNumber() => firebaseRemoteConfig.getInt('mobile_min_supported_build_number');
}
