import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/component/custom_snackbar/custom_snackbar_error.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:flutter_app/core/analytics/crashlytics_manager.dart';
import 'package:flutter_app/core/flogger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'custom_exception.freezed.dart';

@freezed
sealed class CustomException with _$CustomException implements Exception {
  const CustomException._();

  const factory CustomException.general() = CustomExceptionGeneral;
  const factory CustomException.withMessage({String? message}) = CustomExceptionWithMessage;
  const factory CustomException.unauthenticated() = CustomExceptionUnauthenticated;
  const factory CustomException.notConnectedToTheInternet() = CustomExceptionNotConnectedToTheInternet;
  const factory CustomException.decodingFailed() = CustomExceptionDecodingFailed;

  // Note: Mapped Firebase exception with error code `credential-already-in-use`.
  const factory CustomException.signInCancelled() = CustomExceptionSignInCancelled;
  const factory CustomException.credentialAlreadyInUse({required AuthCredential? credential}) = CustomExceptionCredentialAlreadyInUse;

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

          // Note: This is the place to handle your own error codes, response, or states, and map them to you own CustomException.

          if (error.response?.statusCode == 401) {
            return const CustomException.unauthenticated();
          }

          return CustomException.withMessage(message: error.message);
      }
    } else if (error is SignInWithAppleAuthorizationException) {
      switch (error.code) {
        case AuthorizationErrorCode.canceled:
          return CustomException.signInCancelled();
        default:
          return CustomException.withMessage(message: error.message);
      }
    } else if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'credential-already-in-use':
          return CustomException.credentialAlreadyInUse(credential: error.credential);
        default:
          return CustomException.withMessage(message: error.message);
      }
    } else {
      return const CustomException.general();
    }
  }

  String getMessage({required BuildContext context}) {
    return switch (this) {
      CustomExceptionWithMessage(message: final message) => message ?? context.locale.customExceptionGeneralMessage,
      CustomExceptionUnauthenticated() => context.locale.customExceptionUnauthenticatedMessage,
      CustomExceptionNotConnectedToTheInternet() => context.locale.customExceptionInternetConnectionMessage,
      _ => context.locale.customExceptionGeneralMessage,
    };
  }

  String getDetails({required BuildContext context}) {
    return switch (this) {
      CustomExceptionNotConnectedToTheInternet() => context.locale.customExceptionInternetConnectionDetails,
      _ => context.locale.customExceptionGeneralDetails,
    };
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
