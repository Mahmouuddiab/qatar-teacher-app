import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/router/app_router.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init(baseUrl: ApiConstants.baseUrl,enableLogger: true);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qatar Teachers',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: AppSnackBar.messengerKey,
      initialRoute: AppRoutes.onBoarding,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
