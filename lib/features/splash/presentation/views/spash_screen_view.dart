import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sadaqa_app/core/router/app_router.dart';

//  Splash Screen — fade + scale for the logo
class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> opacity;
  late Animation<double> scale;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    scale = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward().then((_) {
      if (mounted) {
        context.push(AppRouter.kLoginview);
      }
    });
    super.initState();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: opacity,
        child: ScaleTransition(
          scale: scale,
          child: Center(
            child: Image(
              image: AssetImage('assets/sadaqa_logo.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
