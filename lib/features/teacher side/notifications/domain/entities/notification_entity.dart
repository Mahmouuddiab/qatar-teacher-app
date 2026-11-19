class NotificationEntity {
  final int id;
  final String title;
  final String body;
  final String type;
  final int? bookingId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.bookingId,
    required this.isRead,
    required this.createdAt,
  });
}