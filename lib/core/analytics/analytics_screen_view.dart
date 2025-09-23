import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_screen_view.freezed.dart';

@freezed
abstract class AnalyticsScreenView with _$AnalyticsScreenView {
  factory AnalyticsScreenView._({
    required String firebaseScreenName,
  }) = _AnalyticsScreenView;

  factory AnalyticsScreenView.homePage() => AnalyticsScreenView._(firebaseScreenName: 'home_page_screen');
  factory AnalyticsScreenView.eventsPage() => AnalyticsScreenView._(firebaseScreenName: 'events_page_screen');
  factory AnalyticsScreenView.favoritesPage() => AnalyticsScreenView._(firebaseScreenName: 'favorites_page_screen');
  factory AnalyticsScreenView.eventDetailPage() => AnalyticsScreenView._(firebaseScreenName: 'event_detail_page_screen');
}
