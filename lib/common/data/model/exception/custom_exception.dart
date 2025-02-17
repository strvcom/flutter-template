import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_error.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/core/analytics/crashlytics_manager.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_exception.freezed.dart';

@freezed
class CustomException with _$CustomException implements Exception {
  const CustomException._();

  const factory CustomException.general() = _General;
  const factory CustomException.withMessage({String? message}) = _CustomExceptionWithMessage;
  const factory CustomException.unauthenticated() = _Unauthenticated;
  const factory CustomException.notConnectedToTheInternet() = _NotConnectedToTheInternet;
  const factory CustomException.decodingFailed() = _DecodingFailed;

  // Title: Mapped Firebase exception with error code `credential-already-in-use`.
  const factory CustomException.signInCancelled() = _SignInCancelled;
  const factory CustomException.credentialAlreadyInUse({required AuthCredential? credential}) = _CredentialAlreadyInUse;

  factory CustomException.fromErrorObject({required Object? error}) {
    Flogger.e('[CustomException] Received error $error, ');

    CrashlyticsManager.logNonCritical(error, stack: StackTrace.current);

    if (error is CustomException) {
      return error;
    } else if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return const CustomException.notConnectedToTheInternet();
        default:
          if (error.response?.data is Map) {
            Flogger.e("[CustomException] error.response: ${error.response?.data["errorCode"]}");
          }

          // Title: This is the place to handle your own error codes, response, or states, and map them to you own CustomException.

          if (error.response?.statusCode == 401) {
            return const CustomException.unauthenticated();
          }

          return CustomException.withMessage(message: error.message);
      }
    } else if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'credential-already-in-use':
          return CustomException.credentialAlreadyInUse(credential: error.credential);
        default:
          return const CustomException.general();
      }
    } else {
      return const CustomException.general();
    }
  }

  String getMessage({required BuildContext context}) {
    return mapOrNull(
          withMessage: (exception) => exception.message,
          unauthenticated: (_) => context.locale.customExceptionUnauthenticatedMessage,
          notConnectedToTheInternet: (_) => context.locale.customExceptionInternetConnectionMessage,
        ) ??
        context.locale.customExceptionGeneralMessage;
  }

  String getDetails({required BuildContext context}) {
    return mapOrNull(
          notConnectedToTheInternet: (_) => context.locale.customExceptionInternetConnectionDetails,
        ) ??
        context.locale.customExceptionGeneralDetails;
  }

  Future<void> showErrorSnackbar({
    required BuildContext context,
    double optionalBottomSpacing = 0,
  }) async {
    await CustomSnackbarError(
      context: context,
      message: getMessage(context: context),
      optionalBottomSpacing: optionalBottomSpacing,
    ).show();
  }
}
