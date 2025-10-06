import 'dart:convert';

import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/core/database/shared_preferences.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_database_user_use_case.g.dart';

@riverpod
Future<UserEntity?> getDatabaseUserUseCase(Ref ref) async {
  final preferences = await ref.read(sharedPreferencesProvider.future);
  final currentUserData = preferences.getString(PreferencesKeys.currentUserData.value);

  if (currentUserData != null) {
    try {
      return UserEntity.fromJson(jsonDecode(currentUserData) as Map<String, dynamic>);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Flogger.e('[CurrentUserEntityState] Error while parsing user data: $e');
      return null;
    }
  } else {
    return null;
  }
}
