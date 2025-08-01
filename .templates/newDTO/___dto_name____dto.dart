import 'package:freezed_annotation/freezed_annotation.dart';

part '___dto_name____dto.freezed.dart';
part '___dto_name____dto.g.dart';

@freezed
abstract class ___DtoName___DTO with _$___DtoName___DTO {
  const factory ___DtoName___DTO({
    String? sampleField,
  }) = ____DtoName___DTO;

  factory ___DtoName___DTO.fromJson(Map<String, dynamic> json) => _$___DtoName___DTOFromJson(json);
}

extension ___DtoName___DTOExtension on ___DtoName___DTO {
  ___DtoName___Entity toEntity() => ___DtoName___Entity(
    sampleField: sampleField,
  );
}
