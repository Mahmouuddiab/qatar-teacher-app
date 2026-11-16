import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../widgets/course_card.dart';
import '../widgets/home_constant.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/upcoming_session_tile.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  void _goToAddCourse(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addCourse);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(title: 'Dashboard'),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.event_available_outlined,
                      value: '24',
                      label: 'Total bookings',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.upcoming_outlined,
                      value: '5',
                      label: 'Upcoming',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.menu_book_outlined,
                      value: '3',
                      label: 'Active courses',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle_outline,
                      value: '16',
                      label: 'Completed',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ---- Quick action ----
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _goToAddCourse(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Course'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kHomePrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ---- Upcoming sessions preview ----
              SectionHeader(
                title: 'Upcoming Sessions',
                actionText: 'See all',
                onAction: () {}, // TODO: go to bookings tab
              ),
              const SizedBox(height: 12),
              const UpcomingSessionTile(
                courseTitle: 'Mathematics for Beginners',
                studentName: 'Ahmed Ali',
                date: '17 Nov',
                time: '04:00 PM - 05:00 PM',
                mode: 'Online',
              ),
              const SizedBox(height: 12),
              const UpcomingSessionTile(
                courseTitle: 'Algebra Essentials',
                studentName: 'Sara Hassan',
                date: '18 Nov',
                time: '06:00 PM - 07:00 PM',
                mode: 'In person',
              ),
              const SizedBox(height: 24),

              // ---- My courses ----
              SectionHeader(
                title: 'My Courses',
                actionText: 'See all',
                onAction: () {}, // TODO: go to courses list
              ),
              const SizedBox(height: 12),
              CourseCard(
                title: 'Mathematics for Beginners',
                subject: 'Mathematics',
                level: 'Beginner',
                pricePerSessionQAR: 150,
                durationMinutes: 60,
                sessionMode: 'Both',
                onTap: () {}, // TODO: course details
              ),
              const SizedBox(height: 12),
              CourseCard(
                title: 'Algebra Essentials',
                subject: 'Mathematics',
                level: 'Intermediate',
                pricePerSessionQAR: 180,
                durationMinutes: 90,
                sessionMode: 'Online',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              CourseCard(
                title: 'Geometry Basics',
                subject: 'Mathematics',
                level: 'Beginner',
                pricePerSessionQAR: 120,
                durationMinutes: 45,
                sessionMode: 'InPerson',
                isActive: false,
                onTap: () {},
              ),

              // space for the floating bottom nav bar
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}