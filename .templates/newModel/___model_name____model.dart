import 'package:freezed_annotation/freezed_annotation.dart';

part '___model_name____model.freezed.dart';

@freezed
abstract class ___ModelName___Model with _$___ModelName___Model {
  const ___ModelName___Model._();

  const factory ___ModelName___Model({
    required String? sampleField,
  }) = ____ModelName___Model;

  factory ___ModelName___Model.fromAPI({required ___ModelName___DTO dto}) {
    return ___ModelName___Model(
      sampleField: dto.sampleField,
    );
  }

  factory ___ModelName___Model.fromStorage({required ___ModelName___DBO dbo}) {
    return ___ModelName___Model(
      sampleField: dbo.sampleField,
    );
  }

  ___ModelName___DBO toStorageDTO() {
    return ___ModelName___DBO(
      sampleField: sampleField,
    );
  }
}
