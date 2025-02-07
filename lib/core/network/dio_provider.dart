import 'package:dio/dio.dart';
import 'package:flutter_app/app/configuration/configuration.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:flutter_app/core/network/dio_authorization_token_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio();
  dio.options.baseUrl = Configuration.instance.apiHostUrl;
  dio.interceptors.addAll([
    // Title: Authorization token interceptor
    DioAuthorizationTokenInterceptor(ref: ref),

    TalkerDioLogger(
      talker: Flogger.talker,
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: false,
        printResponseHeaders: false,
        printResponseMessage: true,
        requestPen: Flogger.colors['httpRequest'],
        responsePen: Flogger.colors['httpResponse'],
        errorPen: Flogger.colors['httpError'],
      ),
    ),
  ]);
  return dio;
}
