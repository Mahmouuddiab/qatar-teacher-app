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
  /// POST: register or update the authenticated user's FCM device token
  static const String registerDeviceToken =
      '/api/notifications/device-token';

  // ==================== Teacher Profile Endpoints ====================

  /// GET: get teacher profile | PUT: update teacher profile
  static const String teacherProfile = '/api/Teacher/profile';

  // ==================== Teacher Home Endpoints ====================

  /// GET: dashboard statistics
  static const String teacherDashboard = '/api/Teacher/dashboard';

  /// GET: booking statistics
  static const String teacherBookingCounts = '/api/Teacher/booking/counts';

  /// GET: preview of upcoming sessions
  static const String teacherUpcomingBookings = '/api/Teacher/booking/upcoming';

  // ==================== Teacher Course Endpoints ====================

  /// GET: all teacher courses | POST: create a course
  static const String teacherCourses = '/api/Teacher/courses';

  ///  PUT: update course
  static String updateTeacherCourse(int id) => '/api/Teacher/courses/$id';

  ///  PUT: delete course
  static String deleteTeacherCourse(int id) => '/api/Teacher/courses/$id';

  /// GET: course details
  static String teacherCourseDetails(int id) => '/api/Teacher/courses/$id';

  // ==================== Teacher Bookings Endpoints ====================

  /// GET: all booking
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

  // ==================== Teacher Notifications Endpoints ====================

  /// GET: Get all teacher notifications
  static const String teacherNotifications =
      '/api/Teacher/notifications';

  /// GET: Get unread notifications count
  static const String teacherNotificationsUnreadCount =
      '/api/Teacher/notifications/unread-count';

  /// PUT: Mark a specific notification as read
  static String markTeacherNotificationAsRead(int id) =>
      '/api/Teacher/notifications/$id/read';

  /// PUT: Mark all notifications as read
  static const String markAllTeacherNotificationsAsRead =
      '/api/Teacher/notifications/read-all';

  // ==================== Student Endpoints ====================

  /// GET (public): subject chips
  static const String studentSubjects = '/api/Student/subjects';

  /// GET (public): latest courses (?pageSize=10&subject=English)
  static const String studentCourses = '/api/Student/courses';

  /// GET (student): bookings (?status=Confirmed&pageSize=3)
  static const String studentBookings = '/api/Student/bookings';

  /// GET (student): notifications (?unreadOnly=false&page=1&pageSize=30)
  static const String studentNotifications = '/api/Student/notifications';

  /// GET (student): { "count": 1 }
  static const String studentNotificationsUnreadCount =
      '/api/Student/notifications/unread-count';

  /// PUT (student): mark one notification as read
  static String studentNotificationRead(int id) =>
      '/api/Student/notifications/$id/read';

  /// PUT (student): mark all notifications as read
  static const String studentNotificationsReadAll =
      '/api/Student/notifications/read-all';

  static String studentBookingCancel(int id) => '$studentBookings/$id/cancel';

  /// GET (student): booking details
  static String studentBookingById(int id) => '/api/Student/bookings/$id';

  static String studentCourseById(int id) => '$studentCourses/$id';

  static String studentTeacherById(int id) => '/api/Student/teachers/$id';

  static const String studentCoursesSearch = '/api/Student/courses/search';

}