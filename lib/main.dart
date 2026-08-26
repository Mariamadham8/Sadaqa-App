import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sadaqa_app/core/dependancy%20injection/di.dart';
import 'package:sadaqa_app/core/router/app_router.dart';
import 'package:sadaqa_app/core/services/fcm%20service/local_notification_service.dart';
import 'package:sadaqa_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:sadaqa_app/features/group/presentation/views/home_view.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/deep_link_service.dart';
import 'package:sadaqa_app/features/group/presentation/widgets/pending_invite_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  //await get<LocalNotificationService>().init();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  await get<DeepLinkService>().init();
  runApp(BlocProvider(create: (_) => get<AuthCubit>()..checkCurrentUser(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().router,
      builder: (context, child) => PendingInviteGate(child: child!),
      title: 'Sadaqa App',
      debugShowCheckedModeBanner: false,
    );
  }
}
