import '../../domain/entities/dashboard_entity.dart';

class UpcomingSessionModel extends UpcomingSessionEntity {
  const UpcomingSessionModel({
    required super.id,
    required super.courseTitle,
    required super.studentName,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.mode,
  });

  factory UpcomingSessionModel.fromJson(Map<String, dynamic> json) {
    return UpcomingSessionModel(
      id: (json['id'] ?? json['bookingId'] ?? 0) as int,
      courseTitle:
      (json['courseTitle'] ?? json['title'] ?? '').toString(),
      studentName: (json['studentName'] ?? '').toString(),
      date: DateTime.tryParse(
        (json['date'] ?? json['sessionDate'] ?? '').toString(),
      ),
      startTime: (json['startTime'] ?? '').toString(),
      endTime: (json['endTime'] ?? '').toString(),
      mode: (json['sessionMode'] ?? json['mode'] ?? '').toString(),
    );
  }
}

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.teacherId,
    required super.teacherName,
    required super.pendingRequests,
    required super.totalEarningsQAR,
    required super.completedClasses,
    required super.averageRating,
    required super.upcomingClasses,
    required super.upcomingSessions,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final sessions = (json['upcomingSessions'] as List? ?? [])
        .map((e) => UpcomingSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return DashboardModel(
      teacherId: (json['teacherId'] ?? 0) as int,
      teacherName: (json['teacherName'] ?? '') as String,
      pendingRequests: (json['pendingRequests'] ?? 0) as int,
      totalEarningsQAR: (json['totalEarningsQAR'] ?? 0) as num,
      completedClasses: (json['completedClasses'] ?? 0) as int,
      averageRating: (json['averageRating'] ?? 0) as num,
      upcomingClasses: (json['upcomingClasses'] ?? 0) as int,
      upcomingSessions: sessions,
    );
  }
}