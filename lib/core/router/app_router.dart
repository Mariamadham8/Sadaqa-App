import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const kSpalshview = '/spalsh';
  final GoRouter router = GoRouter(
    routes: [GoRoute(path: '/spalsh', builder: (context, state) => Center())],
  );
}
