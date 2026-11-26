import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/network/error_message.dart';
import 'package:qatar_teachers/core/params/create_booking_params.dart';
import 'package:qatar_teachers/features/student%20side/home/data/models/student_booking_model.dart';

import '../models/student_booking_details_model.dart';

abstract class StudentBookingDs {
  Future<StudentBookingModel> createBooking(CreateBookingParams params);
  Future<List<StudentBookingModel>> getMyBookings({
    String? status,
    required int page,
    required int pageSize,
  });
  Future<void> cancelBooking(int id);
  Future<StudentBookingDetailsModel> getBookingDetails(int id);
}

class StudentBookingDsImpl implements StudentBookingDs {
  @override
  Future<StudentBookingModel> createBooking(CreateBookingParams params) async {
    try {
      final response = await DioHelper.post(
        path: ApiConstants.studentBookings,
        data: params.toJson(),
        withAuth: true,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final json = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
        return StudentBookingModel.fromJson(json);
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('createBooking error: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<StudentBookingModel>> getMyBookings({
    String? status,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentBookings,
        query: {
          'page': page,
          'pageSize': pageSize,
          if (status != null) 'status': status,
        },
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => StudentBookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('getMyBookings error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> cancelBooking(int id) async {
    try {
      final response = await DioHelper.put(
        path: ApiConstants.studentBookingCancel(id),
        withAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('cancelBooking error: $e');
      throw ServerException();
    }
  }

  @override
  Future<StudentBookingDetailsModel> getBookingDetails(int id) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentBookingById(id),
        withAuth: true,
      );
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final json = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
        return StudentBookingDetailsModel.fromJson(json);
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('getBookingDetails error: $e');
      throw ServerException();
    }
  }
}
