import '../../domain/entities/subject_entity.dart';

class SubjectModel extends SubjectEntity {
  const SubjectModel({super.id, required super.name});

  /// Accepts either a plain string or an object.
  factory SubjectModel.fromJson(dynamic json) {
    if (json is String) return SubjectModel(name: json);

    final map = json as Map<String, dynamic>;
    return SubjectModel(
      id: map['id'] as int?,
      name: (map['name'] ?? map['title'] ?? map['subject'] ?? '').toString(),
    );
  }
}