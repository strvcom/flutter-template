import 'package:flutter_app/common/data/dto/user_response_dto.dart';
import 'package:flutter_app/common/data/entity/user_entity.dart';
import 'package:flutter_app/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_user_use_case.g.dart';

@riverpod
Future<UserEntity> getCurrentUserUseCase(Ref ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get<Map<String, dynamic>>('/v1/users/me');

  return UserResponseDTO.fromJson(response.data!).toEntity();
}
