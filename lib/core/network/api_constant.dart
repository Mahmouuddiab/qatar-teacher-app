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

  /// GET: get teacher profile | PUT: update teacher profile
  static const String teacherProfile = '/api/Teacher/profile';

  // ==================== Teacher Home Endpoints ====================

  /// GET: dashboard statistics
  static const String teacherDashboard = '/api/Teacher/dashboard';

  /// GET: booking statistics
  static const String teacherBookingCounts = '/api/Teacher/bookings/counts';

  /// GET: preview of upcoming sessions
  static const String teacherUpcomingBookings = '/api/Teacher/bookings/upcoming';

  // ==================== Teacher Course Endpoints ====================

  /// GET: all teacher courses | POST: create a course
  static const String teacherCourses = '/api/Teacher/courses';

  /// GET: course details | PUT: update course | DELETE: delete course
  static String teacherCourseById(int id) => '/api/Teacher/courses/$id';

  // ==================== Teacher Bookings Endpoints ====================

  /// GET: all bookings
  static const String teacherBookings = '/api/Teacher/bookings';

  /// GET: booking details
  static String teacherBookingById(int id) => '/api/Teacher/bookings/$id';

  /// PUT: accept / reject / update booking status
  static String teacherBookingStatus(int id) =>
      '/api/Teacher/bookings/$id/status';

  /// PUT: mark booking as completed
  static String teacherBookingComplete(int id) =>
      '/api/Teacher/bookings/$id/complete';

  // ==================== Teacher Schedule Endpoints ====================

  /// GET: teacher availability | POST: add availability
  static const String teacherAvailability = '/api/Teacher/availability';

  /// DELETE: delete availability
  static String teacherAvailabilityById(int id) =>
      '/api/Teacher/availability/$id';
}