import 'package:dio/dio.dart';
import 'package:flutter_app/common/data/model/exception/custom_exception.dart';

extension ResponseExtension on Response {
  /// Tries to downcast `data` as `List<dynamic>`. If decoding failes,
  /// `CustomException.decodingFailed()` is thrown.
  List<dynamic> get listData {
    if (data is List) {
      return data as List;
    } else {
      throw const CustomException.decodingFailed();
    }
  }
}
