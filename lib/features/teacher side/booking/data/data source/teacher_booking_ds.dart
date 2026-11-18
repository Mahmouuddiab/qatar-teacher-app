import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import '../models/booking_model.dart';

abstract class TeacherBookingDs {
  Future<List<BookingModel>> getBookings();
  Future<BookingModel> getBookingDetails(int id);
  Future<void> respondToBooking(int id, bool accept);
}

class TeacherBookingDsImpl implements TeacherBookingDs {
  @override
  Future<List<BookingModel>> getBookings() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherBookings,
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('getBookings error: $e');
      throw ServerException();
    }
  }

  @override
  Future<BookingModel> getBookingDetails(int id) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherBookingById(id),
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final json = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
        return BookingModel.fromJson(json);
      }
      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('getBookingById error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> respondToBooking(int id, bool accept) async {
    try {
      final response = await DioHelper.put(
        path: ApiConstants.teacherBookingStatus(id),
        data: {'accept': accept},
        withAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('respondToBooking error: $e');
      throw ServerException();
    }
  }
}
