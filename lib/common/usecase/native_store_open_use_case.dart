import 'package:flutter_app/app/setup/app_platform.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'native_store_open_use_case.g.dart';

const _playMarketUrl = 'https://play.google.com/store/apps/details?id=';
const _appStoreUrlIOS = 'https://apps.apple.com/app/id';
const _appStoreUrlMacOS = 'https://apps.apple.com/ru/app/g-app-launcher/id';
const _microsoftStoreUrl = 'https://apps.microsoft.com/store/detail/';

final _platformNotSupportedException = Exception('Platform not supported');

/// This exception was thrown when page in store can't be launchd
class CantLaunchPageException implements Exception {
  CantLaunchPageException(this.message) : super();

  final String message;
}

@riverpod
Future<void> nativeStoreOpenUseCase(
  Ref ref, {
  String? androidAppBundleId,
  String? appStoreId,
  String? appStoreIdMacOS,
  String? windowsProductId,
}) async {
  assert(
    appStoreId != null || androidAppBundleId != null || windowsProductId != null || appStoreIdMacOS != null,
    'You must pass one of this parameters',
  );

  try {
    await _open(
      appStoreId,
      appStoreIdMacOS,
      androidAppBundleId,
      windowsProductId,
    );
  } on Exception catch (e, st) {
    Flogger.e([e, st].toString());
    rethrow;
  }
}

Future<void> _open(String? appStoreId, String? appStoreIdMacOS, String? androidAppBundleId, String? windowsProductId) async {
  if (AppPlatform.isWeb) {
    throw Exception('Platform not supported');
  } else if (AppPlatform.isAndroid) {
    await _openAndroid(androidAppBundleId);
    return;
  } else if (AppPlatform.isIOS) {
    await _openIOS(appStoreId);
    return;
  } else if (AppPlatform.isMacOS) {
    await _openMacOS(appStoreId, appStoreIdMacOS);
    return;
  } else if (AppPlatform.isWindows) {
    await _openWindows(windowsProductId);
    return;
  }

  throw _platformNotSupportedException;
}

Future<void> _openAndroid(String? androidAppBundleId) async {
  if (androidAppBundleId != null) {
    await _openUrl('$_playMarketUrl$androidAppBundleId');
  } else {
    throw CantLaunchPageException('androidAppBundleId is not passed');
  }
}

Future<void> _openIOS(String? appStoreId) async {
  if (appStoreId != null) {
    await _openUrl('$_appStoreUrlIOS$appStoreId');
  } else {
    throw CantLaunchPageException('appStoreId is not passed');
  }
}

Future<void> _openMacOS(String? appStoreId, String? appStoreIdMacOS) async {
  if (appStoreId != null || appStoreIdMacOS != null) {
    await _openUrl('$_appStoreUrlMacOS${appStoreIdMacOS ?? appStoreId}');
  } else {
    throw CantLaunchPageException('appStoreId and appStoreIdMacOS is not passed');
  }
}

Future<void> _openWindows(String? windowsProductId) async {
  if (windowsProductId != null) {
    await _openUrl('$_microsoftStoreUrl$windowsProductId');
  } else {
    throw CantLaunchPageException('windowsProductId is not passed');
  }
}

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw CantLaunchPageException('Could not launch $url');
  }
}
