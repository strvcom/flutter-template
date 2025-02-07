import 'package:flutter_app/common/data/dto/user_response_dto.dart';
import 'package:flutter_app/common/data/enum/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required UserRole role,
    required String? email,
    required String? displayName,
    required String? imageUrl,
    required String? referredId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromAPI({required UserResponseDTO user}) {
    return UserModel(
      id: user.id,
      role: user.role,
      email: user.email,
      displayName: user.displayName,
      imageUrl: null,
      referredId: user.referredId,
    );
  }
}
