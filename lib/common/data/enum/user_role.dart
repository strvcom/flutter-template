import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_role.g.dart';

@JsonEnum(valueField: 'value', alwaysCreate: true)
enum UserRole {
  user('user'),
  guest('guest'),
  admin('admin');

  const UserRole(this.value);
  final String value;

  static UserRole? fromString(String? value) => UserRole.values.firstWhereOrNull((e) => e.value == value);
}
