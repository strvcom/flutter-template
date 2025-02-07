import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'format_long_date_use_case.g.dart';

@riverpod
String formatLongDateUseCase(Ref ref, {required DateTime date}) {
  return DateFormat.yMMMd(WidgetsBinding.instance.platformDispatcher.locale.languageCode).format(date);
}
