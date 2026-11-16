import 'package:flutter/material.dart';
import 'package:qatar_teachers/features/auth/presentation/screens/login_screen.dart';
import 'package:qatar_teachers/features/auth/presentation/screens/register_screen.dart';
import 'package:qatar_teachers/features/on%20boarding/screen/onboarding_screen.dart';
import 'package:qatar_teachers/features/teacher%20side/home/presentation/screens/add_course_screen.dart';
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
      case AppRoutes.addCourse:
        return MaterialPageRoute(builder: (_) => const AddCourseScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Not Found"))),
        );
    }
  }
}
