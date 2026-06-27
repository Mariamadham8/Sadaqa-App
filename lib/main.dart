import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sadaqa_app/core/dependancy%20injection/di.dart';
import 'package:sadaqa_app/core/services/fcm%20service/local_notification_service.dart';
import 'package:sadaqa_app/features/group/presentation/views/home_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await get<LocalNotificationService>().init();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sadaqa App',
      debugShowCheckedModeBanner: false,
      home: const UserGroupsView(),
    );
  }
}
