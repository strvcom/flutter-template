import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/usecase/authentication/get_authorization_token_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioAuthorizationTokenInterceptor extends Interceptor {
  DioAuthorizationTokenInterceptor({required this.ref});

  static const requiresAuthDioExtraKey = 'requiresAuth';

  final Ref ref;

  @override
  FutureOr<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // We don't add token to header, when we set `requiresAuthDioExtraKey` to false in `extra`.
    if (options.extra[DioAuthorizationTokenInterceptor.requiresAuthDioExtraKey] == false) {
      return handler.next(options);
    }

    final token = await ref.read(getAuthorizationTokenUseCaseProvider(forceRefresh: false).future);

    options.headers['Authorization'] = 'Bearer $token';

    handler.next(options);
  }
}
