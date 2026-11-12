class AvailabilityEntity {
  final int? id;
  final bool isRecurring;
  final int? dayOfWeek;
  final DateTime? date;
  final String startTime;
  final String endTime;
  final bool isBooked;

  const AvailabilityEntity({
    this.id,
    required this.isRecurring,
    this.dayOfWeek,
    this.date,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });
}