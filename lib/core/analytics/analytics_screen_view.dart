import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_screen_view.freezed.dart';

@freezed
sealed class AnalyticsScreenView with _$AnalyticsScreenView {
  factory AnalyticsScreenView({
    required String firebaseScreenName,
  }) = _AnalyticsScreenView;

  factory AnalyticsScreenView.homePage() => AnalyticsScreenView(firebaseScreenName: 'home_page_screen');
  factory AnalyticsScreenView.eventsPage() => AnalyticsScreenView(firebaseScreenName: 'events_page_screen');
  factory AnalyticsScreenView.favoritesPage() => AnalyticsScreenView(firebaseScreenName: 'favorites_page_screen');
  factory AnalyticsScreenView.eventDetailPage() => AnalyticsScreenView(firebaseScreenName: 'event_detail_page_screen');
}
