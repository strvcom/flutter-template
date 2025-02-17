import 'package:flutter_app/common/data/model/user_model.dart';
import 'package:flutter_app/common/usecase/user/get_database_user_use_case.dart';
import 'package:flutter_app/common/usecase/user/set_database_user_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_model_state.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserModelState extends _$CurrentUserModelState with NullableStateHandler {
  @override
  FutureOr<UserModel?> build() async {
    return await _getUserFromDatabase();
  }

  Future<void> updateCurrentUser(UserModel? user) async {
    Flogger.d('[CurrentUserModelState] Going to set user $user');

    await ref.read(setDatabaseUserUseCaseProvider(user: user).future);

    setStateData(user);
  }

  Future<UserModel?> _getUserFromDatabase() async {
    return await ref.read(getDatabaseUserUseCaseProvider.future);
  }
}
