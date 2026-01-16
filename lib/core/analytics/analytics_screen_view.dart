import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_screen_view.freezed.dart';

@freezed
sealed class AnalyticsScreenView with _$AnalyticsScreenView {
  const factory AnalyticsScreenView.homePage({@Default('home_page_screen') String firebaseScreenName}) = _HomePage;
  const factory AnalyticsScreenView.eventsPage({@Default('events_page_screen') String firebaseScreenName}) = _EventsPage;
  const factory AnalyticsScreenView.favoritesPage({@Default('favorites_page_screen') String firebaseScreenName}) = _FavoritesPage;
  const factory AnalyticsScreenView.eventDetailPage({@Default('event_detail_page_screen') String firebaseScreenName}) = _EventDetailPage;
}
