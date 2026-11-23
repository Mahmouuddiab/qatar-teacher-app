import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/router/app_router.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/services/fcm_services.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  DioHelper.init(baseUrl: ApiConstants.baseUrl, enableLogger: true);

  final container = ProviderContainer();
  await FcmService.instance.init(container);
  FcmService.instance.registerToken();

  runApp(
    UncontrolledProviderScope(container: container, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qatar Teachers',
      debugShowCheckedModeBanner: false,
      navigatorKey: FcmService.instance.navigatorKey,
      scaffoldMessengerKey: AppSnackBar.messengerKey,
      initialRoute: AppRoutes.onBoarding,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}