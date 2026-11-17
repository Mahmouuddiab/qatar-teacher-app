import 'package:flutter/material.dart';
import 'package:qatar_teachers/features/auth/presentation/screens/change_password_screen.dart';
import 'package:qatar_teachers/features/auth/presentation/screens/login_screen.dart';
import 'package:qatar_teachers/features/auth/presentation/screens/register_screen.dart';
import '../../features/on boarding/screen/onboarding_screen.dart';
import '../../features/teacher side/home/domain/entities/course_entity.dart';
import '../../features/teacher side/home/presentation/screens/add_course_screen.dart';
import '../../features/teacher side/home/presentation/screens/all_courses_screen.dart';
import '../../features/teacher side/home/presentation/screens/course_details_screen.dart';
import '../../features/teacher side/home/presentation/screens/edit_course_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

      case AppRoutes.addCourse:
        return MaterialPageRoute(builder: (_) => const AddCourseScreen());
      case AppRoutes.allCourses:
        return MaterialPageRoute(builder: (_) => const AllCoursesScreen());
      case AppRoutes.courseDetails:
        final courseId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(courseId: courseId),
        );
      case AppRoutes.editCourse:
        final course = settings.arguments as CourseEntity;
        return MaterialPageRoute(
          builder: (_) => EditCourseScreen(course: course),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
          const Scaffold(body: Center(child: Text("Not Found"))),
        );
    }
  }
}