import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/core/routing/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Hiệu ứng splash delay nhẹ
    await Future.delayed(const Duration(seconds: 2));

    // Kiểm tra trạng thái người dùng hiện tại
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Nếu chưa đăng nhập → vào Login
      if (mounted) context.go(AppRoutes.login);
    } else {
      // Nếu đã đăng nhập → vào Home
      if (mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4CAF50), Color(0xFFFFFFFF)],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/3Care.png',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
