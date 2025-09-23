import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_device_token_request_dto.freezed.dart';
part 'create_device_token_request_dto.g.dart';

@Freezed(toJson: true)
abstract class CreateDeviceTokenRequestDTO with _$CreateDeviceTokenRequestDTO {
  const factory CreateDeviceTokenRequestDTO({
    required String? token,
  }) = _CreateDeviceTokenRequestDTO;
}
