class UpcomingSessionEntity {
  final int id;
  final String courseTitle;
  final String studentName;
  final DateTime? date;
  final String startTime;
  final String endTime;
  final String mode;

  const UpcomingSessionEntity({
    required this.id,
    required this.courseTitle,
    required this.studentName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.mode,
  });
}

class DashboardEntity {
  final int teacherId;
  final String teacherName;
  final int pendingRequests;
  final num totalEarningsQAR;
  final int completedClasses;
  final num averageRating;
  final int upcomingClasses;
  final List<UpcomingSessionEntity> upcomingSessions;

  const DashboardEntity({
    required this.teacherId,
    required this.teacherName,
    required this.pendingRequests,
    required this.totalEarningsQAR,
    required this.completedClasses,
    required this.averageRating,
    required this.upcomingClasses,
    required this.upcomingSessions,
  });
}