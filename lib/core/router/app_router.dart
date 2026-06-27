import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/features/auth/presentation/views/login_view.dart';
import 'package:sadaqa_app/features/auth/presentation/views/signup.dart';

class AppRouter {
  static const kSpalshview = '/spalsh';
  static const kLoginview = '/login';
  static const kSignupview = '/signup';
  final GoRouter router = GoRouter(
    routes: [
    
       GoRoute(path: '/', builder: (context, state) => LoginView()),
       GoRoute(path: '/login', builder: (context, state) => LoginView()),
      GoRoute(path: '/spalsh', builder: (context, state) => Center()),
      GoRoute(path: '/signup', builder: (context, state) => SignupView()),
    ],
  );
}
