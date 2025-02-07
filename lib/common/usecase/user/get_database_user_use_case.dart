import 'dart:convert';

import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/core/database/shared_preferences.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_database_user_use_case.g.dart';

@riverpod
Future<UserModel?> getDatabaseUserUseCase(Ref ref) async {
  final preferences = await ref.read(sharedPreferencesProvider.future);
  final currentUserData = preferences.getString(PreferencesKeys.currentUserData.value);

  if (currentUserData != null) {
    try {
      return UserModel.fromJson(jsonDecode(currentUserData));
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      Flogger.e('[CurrentUserModelState] Error while parsing user data: $e');
      return null;
    }
  } else {
    return null;
  }
}
