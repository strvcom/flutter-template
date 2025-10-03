import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

enum PreferencesKeys {
  currentUserData('current_user_data'),
  themeMode('theme_mode');

  const PreferencesKeys(this.value);
  final String value;
}

@Riverpod(keepAlive: true)
FutureOr<SharedPreferences> sharedPreferences(Ref ref) async {
  return await SharedPreferences.getInstance();
}
