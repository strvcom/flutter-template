import 'dart:convert';

import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/core/database/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'set_database_user_use_case.g.dart';

@riverpod
Future<void> setDatabaseUserUseCase(
  Ref ref, {
  required UserEntity? user,
}) async {
  final preferences = await ref.read(sharedPreferencesProvider.future);

  if (user == null) {
    await preferences.remove(PreferencesKeys.currentUserData.value);
  } else {
    await preferences.setString(PreferencesKeys.currentUserData.value, jsonEncode(user));
  }
}
