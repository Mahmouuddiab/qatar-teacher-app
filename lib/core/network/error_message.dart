import 'dart:convert';
import 'package:dio/dio.dart';

const String _defaultMessage = 'Server error occurred';

String _extractMessage(dynamic data) {
  if (data is String) {
    try {
      data = jsonDecode(data);
    } catch (_) {}
  }
  if (data is Map && data['message'] is String) {
    return data['message'] as String;
  }
  return _defaultMessage;
}

/// For a DioException (thrown on error status codes)
String messageFromDio(DioException e) => _extractMessage(e.response?.data);

/// For a Response (when DioHelper returns 4xx instead of throwing)
String messageFromResponse(Response response) => _extractMessage(response.data);