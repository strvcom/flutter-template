import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/common/data/enum/user_role.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_completion_use_case.g.dart';

@riverpod
Future<UserEntity> signInCompletionUseCase(Ref ref) async {
  try {
    Flogger.d('[Authentication] Going to sign in user on BE');

    /*
    final dio = ref.read(dioProvider);
    final response = await dio.post('v1/sign-in');
    final userResponse = UserResponseDTO.fromJson(response.data);
    final user = UserEntity.fromAPI(user: userResponse);
    */

    // TODO(strv): Remove this line and uncomment the above lines
    const user = UserEntity(
      id: '1',
      email: 'john.doe@example.com',
      displayName: 'John Doe',
      imageUrl: 'https://randomuser.me/api/portraits',
      role: UserRole.user,
      referredId: '1',
    );

    Flogger.d('[Authentication] Received new user from BE $user');

    return user;
  } catch (e) {
    Flogger.e('[Authentication] Error during sign in completion: $e');
    throw CustomException.fromErrorObject(error: e);
  }
}
