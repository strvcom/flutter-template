import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/common/usecase/user/get_database_user_use_case.dart';
import 'package:flutter_app/common/usecase/user/set_database_user_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_state.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserState extends _$CurrentUserState with NullableStateHandler {
  @override
  FutureOr<UserEntity?> build() async {
    return await _getUserFromDatabase();
  }

  Future<void> updateCurrentUser(UserEntity? user) async {
    Flogger.d('[CurrentUserEntityState] Going to set user $user');

    await ref.read(setDatabaseUserUseCaseProvider(user: user).future);

    setStateData(user);
  }

  Future<UserEntity?> _getUserFromDatabase() async {
    return await ref.read(getDatabaseUserUseCaseProvider.future);
  }
}
