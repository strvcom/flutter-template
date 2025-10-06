import 'package:flutter_app/common/data/entity/exception/custom_exception.dart';
import 'package:flutter_app/common/provider/current_user_state.dart';
import 'package:flutter_app/common/usecase/authentication/sign_out_use_case.dart';
import 'package:flutter_app/common/usecase/get_random_image_url_use_case.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/core/riverpod/state_handler.dart';
import 'package:flutter_app/features/profile/profile_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_state.freezed.dart';
part 'profile_state.g.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    required String displayName,
    required String imageUrl,
    required bool isSigningOut,
  }) = _ProfileState;
}

@riverpod
class ProfileStateNotifier extends _$ProfileStateNotifier with AutoDisposeStateHandler {
  @override
  FutureOr<ProfileState> build() async {
    final currentUser = await ref.read(currentUserStateProvider.future);
    final imageUrl = ref.read(getRandomImageUrlUseCaseProvider(width: 120, height: 120));

    await Future<void>.delayed(const Duration(seconds: 2));

    return ProfileState(
      displayName: currentUser?.displayName ?? '',
      imageUrl: imageUrl,
      isSigningOut: false,
    );
  }

  Future<void> signOut() async {
    setStateData(currentData?.copyWith(isSigningOut: true));

    try {
      await ref.read(signOutUseCaseProvider.future);

      ref.read(profileEventNotifierProvider.notifier).send(const ProfileEvent.signedOut());
    } on Exception catch (error) {
      final customException = CustomException.fromErrorObject(error: error);
      Flogger.e('Error: $customException');
    }

    setStateData(currentData?.copyWith(isSigningOut: false));
  }
}
