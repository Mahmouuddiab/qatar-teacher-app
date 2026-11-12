import '../../domain/entity/availability_entity.dart';

class AvailabilityModel extends AvailabilityEntity {
  const AvailabilityModel({
    super.id,
    required super.isRecurring,
    super.dayOfWeek,
    super.date,
    required super.startTime,
    required super.endTime,
    super.isBooked,
  });

  factory AvailabilityModel.fromEntity(AvailabilityEntity e) =>
      AvailabilityModel(
        isRecurring: e.isRecurring,
        dayOfWeek: e.dayOfWeek,
        date: e.date,
        startTime: e.startTime,
        endTime: e.endTime,
      );

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) =>
      AvailabilityModel(
        id: json['id'] as int?,
        isRecurring: json['isRecurring'] as bool,
        dayOfWeek: json['dayOfWeek'] as int?,
        date: json['date'] != null
            ? DateTime.parse(json['date'] as String)
            : null,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        isBooked: json['isBooked'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'isRecurring': isRecurring,
    'dayOfWeek': isRecurring ? dayOfWeek : null,
    'date': isRecurring ? null : date?.toUtc().toIso8601String(),
    'startTime': startTime,
    'endTime': endTime,
  };
}