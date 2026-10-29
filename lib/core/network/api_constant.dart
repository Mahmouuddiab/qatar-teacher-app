class ApiConstants {
  ApiConstants._();

  // ==================== Base URL ====================

  static const String baseUrl = 'https://dev-qatar-teachers.runasp.net';

  // ==================== Auth Endpoints ====================

  static const String register = '/api/Auth/register';
  static const String login = '/api/Auth/login';
  static const String profile = '/api/Auth/profile';
  static const String updateProfile = '/api/Auth/profile';
  static const String changePassword = '/api/Auth/change-password';
  static const String logout = '/api/Auth/logout';

  // ==================== Teacher Profile Endpoints ====================

  static const String updateTeacherProfile = '/api/Teacher/profile';

  static String teacherProfile(String id) => '/api/Teacher/profile/$id';

  static const String createTeacherAvailability = '/api/Teacher/availability';

  static const String teacherAvailability = '/api/Teacher/availability';

  static const String deleteTeacherAvailability = '/api/Teacher/availability';

  static const String teacherBookings = '/api/Teacher/bookings';

  static const String updateTeacherBookingStatus = '/api/Teacher/bookings';

  static const String completeTeacherBooking = '/api/Teacher/bookings';

  static const String teacherDashboard = '/api/Teacher/dashboard';
}
