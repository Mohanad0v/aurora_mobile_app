// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/auth/data/datasource/auth_local.dart';
import '../constants/app_url/app_strings.dart';
import '../injection/injection.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioException error) {
  if (error.response != null && error.response?.statusCode != null) {
    final statusCode = error.response!.statusCode!;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        final errorData = error.response?.data;
        if (errorData is Map<String, dynamic>) {
          final message = errorData["message"] ?? errorData["error"];
          final errorCode = errorData["error_code"];

          if (errorCode == AppStrings.strTokenFailed) {
            return Failure(error.response!.statusCode!, errorCode);
          }
          if (errorCode == AppStrings.strPasswordMustChange) {
            return Failure(error.response!.statusCode!, errorCode);
          }

          if (errorCode != null && message.isNotEmpty) {
            return Failure(error.response!.statusCode!, message);
          }

          if (errorCode != null) {
            return getKnownErrors(
              error: errorCode,
              code: error.response!.statusCode!,
            );
          } else {
            return DataSource.DEFAULT.getFailure();
          }
        } else {
          return DataSource.DEFAULT.getFailure();
        }

      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      case DioExceptionType.unknown:
        return DataSource.UNKNOWN.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.BADCERTIFCAITE.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  } else {
    return DataSource.DEFAULT.getFailure();
  }
}

Failure getKnownErrors({
  required String error,
  required int code,
}) {
  switch (error) {
    case 'API:LOGIN_FAILED':
      return Failure(ResponseCode.DEFAULT, ResponseErrorKnown.LOGIN_FAILED.tr());
    case 'API:PASSWORD_MUST_CHANGE':
      return Failure(ResponseCode.DEFAULT, ResponseErrorKnown.PASSWORD_MUST_CHANGE.tr());
    case 'API:TOKEN_FAILED':
      return Failure(ResponseCode.DEFAULT, ResponseErrorKnown.TOKEN_FAILED.tr());
    case 'Authentication failed':
      return Failure(ResponseCode.DEFAULT, ResponseErrorKnown.TOKEN_FAILED.tr());
    case "API:CURRENT_PASSWORD_NOT_CORRECT":
      return Failure(ResponseCode.DEFAULT, ResponseErrorKnown.PASSWORD_NOT_CORRECT.tr());
    case "Current password not correct":
      return Failure(ResponseCode.DEFAULT, ResponseErrorKnown.PASSWORD_NOT_CORRECT.tr());
    default:
      return Failure(code, error);
  }
}

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
  BADCERTIFCAITE,
  UNKNOWN
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS.tr());
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT.tr());
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST.tr());
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN.tr());
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED.tr());
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND.tr());
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(ResponseCode.INTERNAL_SERVER_ERROR, ResponseMessage.INTERNAL_SERVER_ERROR.tr());
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT.tr());
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL.tr());
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(ResponseCode.RECIEVE_TIMEOUT, ResponseMessage.RECIEVE_TIMEOUT.tr());
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT.tr());
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR.tr());
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION, ResponseMessage.NO_INTERNET_CONNECTION.tr());
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT.tr());
      case DataSource.UNKNOWN:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.UNKNOWN.tr());
      case DataSource.BADCERTIFCAITE:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.BADCERTIFCAITE.tr());
    }
  }
}

class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404; // failure, not found

  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
}

class ResponseMessage {
  static const String SUCCESS = AppStrings.success; // success with data
  static const String NO_CONTENT = AppStrings.success; // success with no data (no content)
  static const String BAD_REQUEST = AppStrings.strBadRequestError; // failure, API rejected request
  static const String UNAUTORISED = AppStrings.strUnauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN = AppStrings.strForbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR = AppStrings.strInternalServerError; // failure, crash in server side
  static const String NOT_FOUND = AppStrings.strNotFoundError; // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = AppStrings.strTimeoutError;
  static const String CANCEL = AppStrings.strDefaultError;
  static const String RECIEVE_TIMEOUT = AppStrings.strTimeoutError;
  static const String SEND_TIMEOUT = AppStrings.strTimeoutError;
  static const String CACHE_ERROR = AppStrings.strCacheError;
  static const String NO_INTERNET_CONNECTION = AppStrings.strNoInternetError;
  static const String DEFAULT = AppStrings.strDefaultError;
  static const String UNKNOWN = AppStrings.strUnknownError;
  static const String BADCERTIFCAITE = AppStrings.strNotFoundError; // failure, crash in server side
}

class ResponseErrorKnown {
  static const String LOGIN_FAILED = AppStrings.strLoginFail;
  static const String PASSWORD_MUST_CHANGE = AppStrings.strPasswordMustChange;
  static const String TOKEN_FAILED = AppStrings.strTokenFailed;
  static const String PASSWORD_NOT_CORRECT = AppStrings.strPasswordNotCorrect;
}
//
// class ApiInternalStatus {
//   static const int SUCCESS = 200;
//   static const int FAILURE = 400;
// }
