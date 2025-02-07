import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/core/analytics/analytics_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_manager.g.dart';

@riverpod
Future<void> analyticsManagerUpdateUserInfo(Ref ref, {required UserModel? user}) async {
  FirebaseAnalytics.instance
    ..setUserId(id: user?.id)
    ..setUserProperty(name: 'display_name', value: user?.displayName);
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
