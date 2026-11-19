import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

// ---------------------------------------------------------------------------
// UI models (replace with your entities/mappers when the endpoints are wired)
// ---------------------------------------------------------------------------

class _SubjectUi {
  final String name;
  final IconData icon;
  const _SubjectUi(this.name, this.icon);
}

class _SessionUi {
  final String subject;
  final String teacherName;
  final String dateLabel;
  final String timeLabel;
  final String mode;
  const _SessionUi({
    required this.subject,
    required this.teacherName,
    required this.dateLabel,
    required this.timeLabel,
    required this.mode,
  });
}

class _CourseUi {
  final String title;
  final String teacherName;
  final String subject;
  final String level;
  final String price;
  final int durationMinutes;
  final String mode;
  const _CourseUi({
    required this.title,
    required this.teacherName,
    required this.subject,
    required this.level,
    required this.price,
    required this.durationMinutes,
    required this.mode,
  });
}

const _sampleSubjects = [
  _SubjectUi('All', Icons.apps_rounded),
  _SubjectUi('Mathematics', Icons.calculate_outlined),
  _SubjectUi('Physics', Icons.science_outlined),
  _SubjectUi('English', Icons.translate_rounded),
  _SubjectUi('Arabic', Icons.menu_book_outlined),
  _SubjectUi('Chemistry', Icons.biotech_outlined),
];

const _sampleSessions = [
  _SessionUi(
    subject: 'Advanced English Course',
    teacherName: 'Omar Kaf',
    dateLabel: 'Thu, 26 Nov',
    timeLabel: '5:00 PM',
    mode: 'Online',
  ),
  _SessionUi(
    subject: 'Mathematics for Beginners',
    teacherName: 'Omar Kaf',
    dateLabel: 'Sat, 28 Nov',
    timeLabel: '7:00 PM',
    mode: 'InPerson',
  ),
];

const _sampleCourses = [
  _CourseUi(
    title: 'Advanced English Course',
    teacherName: 'Omar Kaf',
    subject: 'English',
    level: 'Advanced',
    price: 'QAR 150',
    durationMinutes: 60,
    mode: 'Online',
  ),
  _CourseUi(
    title: 'Mathematics for Beginners',
    teacherName: 'Omar Kaf',
    subject: 'Mathematics',
    level: 'Beginner',
    price: 'QAR 120',
    durationMinutes: 45,
    mode: 'Both',
  ),
  _CourseUi(
    title: 'Physics Essentials',
    teacherName: 'Sara Ahmed',
    subject: 'Physics',
    level: 'Intermediate',
    price: 'QAR 180',
    durationMinutes: 90,
    mode: 'InPerson',
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // Space for the floating bottom nav bar
  static const double _bottomSpace = 120;

  String _selectedSubject = 'All';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, _bottomSpace),
            children: [
              const _GreetingHeader(name: 'Mahmoud'),
              const SizedBox(height: 16),
              _SearchShortcut(
                onTap: () {}, // TODO: switch to Explore tab
              ),
              const SizedBox(height: 20),

              // ---- Subjects ----
              _SubjectsRow(
                subjects: _sampleSubjects,
                selected: _selectedSubject,
                onSelected: (s) => setState(() => _selectedSubject = s),
              ),
              const SizedBox(height: 24),

              // ---- Upcoming sessions ----
              _SectionTitle(
                title: 'Upcoming Sessions',
                onViewAll: () {}, // TODO: switch to Bookings tab
              ),
              const SizedBox(height: 12),
              if (_sampleSessions.isEmpty)
                const _EmptyBox(
                  icon: Icons.event_busy_outlined,
                  message: 'No upcoming sessions',
                )
              else
                for (int i = 0; i < _sampleSessions.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _SessionCard(session: _sampleSessions[i]),
                ],
              const SizedBox(height: 24),

              // ---- Recommended courses ----
              _SectionTitle(
                title: 'Recommended Courses',
                onViewAll: () {}, // TODO: switch to Explore tab
              ),
              const SizedBox(height: 12),
              if (_sampleCourses.isEmpty)
                const _EmptyBox(
                  icon: Icons.menu_book_outlined,
                  message: 'No courses yet',
                )
              else
                for (int i = 0; i < _sampleCourses.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  _CourseCard(
                    course: _sampleCourses[i],
                    onTap: () {}, // TODO: course details
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Greeting + search
// ---------------------------------------------------------------------------

class _GreetingHeader extends StatelessWidget {
  final String name;
  const _GreetingHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLight,
          child: Text(
            initial,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchShortcut extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchShortcut({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.textSecondary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search courses or teachers',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Subjects
// ---------------------------------------------------------------------------

class _SubjectsRow extends StatelessWidget {
  final List<_SubjectUi> subjects;
  final String selected;
  final ValueChanged<String> onSelected;

  const _SubjectsRow({
    required this.subjects,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = subjects[i];
          final isSelected = s.name == selected;
          return Material(
            color: isSelected ? AppColors.primary : AppColors.surface,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => onSelected(s.name),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      s.icon,
                      size: 18,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section title
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const _SectionTitle({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
          ),
          child: const Text(
            'View all',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Session card
// ---------------------------------------------------------------------------

class _SessionCard extends StatelessWidget {
  final _SessionUi session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final isOnline = session.mode.toLowerCase() == 'online';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isOnline ? Icons.videocam_outlined : Icons.place_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'with ${session.teacherName}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.dateLabel,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      session.timeLabel,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _Tag(
            text: session.mode,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Course card
// ---------------------------------------------------------------------------

class _CourseCard extends StatelessWidget {
  final _CourseUi course;
  final VoidCallback onTap;
  const _CourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.menu_book_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              size: 15,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                course.teacherName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Tag(text: course.subject),
                  _Tag(text: course.level),
                  _Tag(text: course.mode),
                ],
              ),
              const Divider(height: 24, color: AppColors.border),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${course.durationMinutes} min',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    course.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    ' / session',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small shared pieces
// ---------------------------------------------------------------------------

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyBox extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyBox({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 36, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}