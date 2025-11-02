import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Sau 5 giây tự động chuyển đến màn hình đăng nhập
    Timer(const Duration(seconds: 5), () {
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50), // Xanh lá tươi ở trên
              Color(0xFFFFFFFF), // Trắng ở dưới
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (ảnh splash bạn gửi)
              Image.asset(
                'assets/images/3Care.png', // Đặt đúng tên ảnh của bạn
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "3Care",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2), // Màu xanh dương logo
                ),
              ),
              const Text(
                "BOOKING MEDICAL",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1.5,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
