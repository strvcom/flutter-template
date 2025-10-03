import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/core/analytics/analytics_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_manager.g.dart';

@riverpod
Future<void> analyticsManagerUpdateUserInfo(Ref ref, {required UserEntity? user}) async {
  await FirebaseAnalytics.instance.setUserId(id: user?.id);
  await FirebaseAnalytics.instance.setUserProperty(name: 'display_name', value: user?.displayName);
}

@riverpod
Future<void> analyticsManagerLogScreenView(Ref ref, String screenName) async {
  if (Firebase.apps.isNotEmpty) {
    await FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }
}

@riverpod
Future<void> analyticsManagerLogEvent(Ref ref, AnalyticsEvent event) async {
  if (Firebase.apps.isNotEmpty) {
    await FirebaseAnalytics.instance.logEvent(name: event.firebaseEventId, parameters: event.firebaseEventParams);
  }
}
