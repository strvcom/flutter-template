import 'package:flutter_app/common/data/dto/create_device_token_request_dto.dart';
import 'package:flutter_app/core/network/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_device_token_use_case.g.dart';

@riverpod
Future<void> createDeviceTokenUseCase(
  Ref ref, {
  required String? deviceToken,
}) async {
  final dio = ref.read(dioProvider);

  // TODO: Register FCM token on API
  await dio.post(
    '/v1/device-tokens',
    data: CreateDeviceTokenRequestDTO(token: deviceToken).toJson(),
  );
}
