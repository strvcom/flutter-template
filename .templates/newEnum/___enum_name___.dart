import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '___enum_name___.g.dart';

@JsonEnum(valueField: 'value', alwaysCreate: true)
enum ___EnumName___ {
  sample('sample');

  const ___EnumName___(this.value);
  final String value;

  static ___EnumName___? fromString(String? value) => ___EnumName___.values.firstWhereOrNull((e) => e.value == value);
}
