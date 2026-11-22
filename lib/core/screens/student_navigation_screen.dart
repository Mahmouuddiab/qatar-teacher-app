import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import 'package:qatar_teachers/features/student%20side/home/presentation/screens/student_home_screen.dart';
import 'package:qatar_teachers/features/student%20side/explore/presentation/screens/student_explore_screen.dart';
import 'package:qatar_teachers/features/student%20side/booking/presentation/screens/student_booking_screen.dart';
import 'package:qatar_teachers/features/student%20side/profile/presentation/screens/student_profile_screen.dart';

class StudentNavigationScreen extends StatefulWidget {
  const StudentNavigationScreen({super.key, this.userName = 'Student'});

  /// Shown in the home greeting. Pass the real profile name from the caller
  /// (or replace this with a profile provider lookup).
  final String userName;

  @override
  State<StudentNavigationScreen> createState() =>
      _StudentNavigationScreenState();
}

class _StudentNavigationScreenState extends State<StudentNavigationScreen> {
  static const int _homeIndex = 0;
  static const int _exploreIndex = 1;
  static const int _bookingsIndex = 2;

  int _currentIndex = _homeIndex;

  late final List<Widget> _tabs;

  static const List<_NavigationItem> _items = [
    _NavigationItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    _NavigationItem(
      label: 'Explore',
      icon: Icons.search_rounded,
      activeIcon: Icons.manage_search_rounded,
    ),
    _NavigationItem(
      label: 'Bookings',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_month_rounded,
    ),
    _NavigationItem(
      label: 'Account',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _tabs = [
      StudentHomeScreen(
        userName: widget.userName,
        onNotificationsTap: _openNotifications,
        onSearchTap: () => _goTo(_exploreIndex),
        onViewAllSessions: () => _goTo(_bookingsIndex),
        onViewAllCourses: () => _goTo(_exploreIndex),
        onCourseTap: _openCourse,
      ),
      const StudentExploreScreen(),
      const StudentBookingScreen(),
      const StudentProfileScreen(),
    ];
  }

  void _goTo(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  void _openNotifications() {
    // TODO: push the student notifications screen once it exists.
  }

  void _openCourse(StudentCourseEntity course) {
    // TODO: push the course details screen once it exists (course.id).
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = AppColors.primary;
    final secondaryColor = AppColors.textSecondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = _currentIndex == index;

              return Expanded(
                child: _NavigationTab(
                  item: item,
                  isSelected: isSelected,
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                  onTap: () => _goTo(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavigationTab extends StatelessWidget {
  const _NavigationTab({
    required this.item,
    required this.isSelected,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool isSelected;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withValues(alpha: 0.10)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: isSelected ? primaryColor : secondaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? primaryColor : secondaryColor,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}