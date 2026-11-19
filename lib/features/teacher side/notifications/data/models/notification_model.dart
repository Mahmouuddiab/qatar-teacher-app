import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    required super.bookingId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      bookingId: json['bookingId'] as int?,
      isRead: (json['isRead'] ?? false) as bool,
      // No "Z" in the sample. If the server sends UTC, use
      // DateTime.parse('${raw}Z') so the relative time is correct.
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}