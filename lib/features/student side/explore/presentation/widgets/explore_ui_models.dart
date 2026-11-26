import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';

class ExploreCourseUi {
  final int id;
  final int teacherId;
  final String title;
  final String teacherName;
  final String subject;
  final String level;
  final String description;
  final String mode;
  final String price;
  final int durationMinutes;
  final num priceValue; // numeric price, used by the Book Now sheet

  const ExploreCourseUi({
    required this.id,
    required this.teacherId,
    required this.title,
    required this.teacherName,
    required this.subject,
    required this.level,
    required this.description,
    required this.mode,
    required this.price,
    required this.durationMinutes,
    this.priceValue = 0,
  });

  /// Used by the Book Now sheet.
  StudentCourseEntity toEntity() => StudentCourseEntity(
    id: id,
    teacherId: teacherId,
    teacherName: teacherName,
    title: title,
    subject: subject,
    description: description,
    level: level,
    pricePerSessionQAR: priceValue,
    durationMinutes: durationMinutes,
    sessionMode: mode,
    isActive: true,
    createdAt: DateTime.now(),
  );
}

class TeacherUi {
  final int id;
  final String name;
  final String bio;
  final String qualifications;
  final List<String> subjects;
  final List<String> languages;
  final num rating;
  final int yearsOfExperience;

  const TeacherUi({
    required this.id,
    required this.name,
    required this.bio,
    required this.qualifications,
    required this.subjects,
    required this.languages,
    required this.rating,
    required this.yearsOfExperience,
  });
}

// ---------------- Sample data (remove when the endpoints are wired) ----------------

const sampleSubjects = ['English', 'Mathematics', 'Physics', 'Arabic'];

const sampleTeacher = TeacherUi(
  id: 2,
  name: 'Omar Kaf',
  bio: 'Experienced Mathematics and Physics teacher with over 8 years of '
      'international teaching experience.',
  qualifications: 'Master of Science in Mathematics, University of Manchester',
  subjects: ['Mathematics', 'Physics'],
  languages: ['English', 'Arabic'],
  rating: 5,
  yearsOfExperience: 8,
);

final sampleExploreCourses = List.generate(30, (i) {
  const subjects = sampleSubjects;
  const levels = ['Beginner', 'Intermediate', 'Advanced'];
  const modes = ['Online', 'InPerson', 'Both'];
  final subject = subjects[i % subjects.length];
  final priceValue = 100 + (i % 5) * 20;
  return ExploreCourseUi(
    // NOTE: the booking API needs real course ids. Your backend has 2 and 3,
    // so sample ids 1..30 will be rejected when booking.
    id: i + 1,
    teacherId: 2,
    title: '$subject ${levels[i % 3]} Course ${i + 1}',
    teacherName: 'Omar Kaf',
    subject: subject,
    level: levels[i % 3],
    description: 'A comprehensive course covering fundamental concepts, '
        'problem-solving techniques and practical exercises.',
    mode: modes[i % 3],
    price: 'QAR $priceValue',
    priceValue: priceValue,
    durationMinutes: 45 + (i % 3) * 15,
  );
});