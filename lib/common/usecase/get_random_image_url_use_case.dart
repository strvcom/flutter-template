import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_random_image_url_use_case.g.dart';

@riverpod
String getRandomImageUrlUseCase(Ref ref, {required int width, required int height}) {
  return 'https://picsum.photos/seed/${Random().nextInt(1000)}/$width/$height';
}
