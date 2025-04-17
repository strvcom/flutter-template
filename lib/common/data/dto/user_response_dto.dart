import 'package:flutter_app/common/data/enum/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response_dto.freezed.dart';
part 'user_response_dto.g.dart';

@freezed
abstract class UserResponseDTO with _$UserResponseDTO {
  const factory UserResponseDTO({
    required String id,
    required UserRole role,
    String? email,
    String? displayName,
    String? referredId,
  }) = _UserResponseDTO;

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) => _$UserResponseDTOFromJson(json);
}
