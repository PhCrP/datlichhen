import 'package:datlichhen/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Hàm build icon PNG với kích thước chuẩn
  Widget _pngIcon(String assetPath, {double size = 24, Color? color}) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color, // áp dụng màu tint nếu cần
      errorBuilder: (_, __, ___) => const Icon(Icons.error, size: 20, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔹 Thanh xanh trên cùng
          Container(
            height: 43.27,
            width: double.infinity,
            color: const Color(0xFF43B02A),
          ),

          // 🔹 AppBar trắng có bo góc dưới
          Container(
            height: 97,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '3Care',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: _pngIcon('assets/icons/notification.png', size: 26),
                        onPressed: () => context.push(AppRoutes.notification),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: _pngIcon('assets/icons/menu.png', size: 28.5),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Thẻ thống kê
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Container(
                margin: const EdgeInsets.only(top: 35),
                height: 587,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    _buildStatCard(
                      context,
                      iconPath: 'assets/icons/doctor_2.png',
                      title: "Bác sĩ",
                      count: 13,
                      onTap: () => context.push(AppRoutes.doctor),
                    ),
                    _buildStatCard(
                      context,
                      iconPath: 'assets/icons/patient_2.png',
                      title: "Bệnh nhân",
                      count: 100,
                      onTap: () {},
                    ),
                    _buildStatCard(
                      context,
                      iconPath: 'assets/icons/calendar_2.png',
                      title: "Lịch hẹn",
                      count: 13,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 BottomNavigationBar
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() => _currentIndex = index);
                  if (index == 0) context.push(AppRoutes.home);
                  if (index == 1) context.push(AppRoutes.doctor);
                },
                backgroundColor: Colors.white,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.black,
                
                items: [
                  BottomNavigationBarItem(
                    icon: _pngIcon('assets/icons/home.png', color: Colors.black),
                    activeIcon: _pngIcon('assets/icons/home.png', color: Colors.green),
                    label: 'Trang chủ',
                  ),
                  BottomNavigationBarItem(
                    icon: _pngIcon('assets/icons/doctor.png', color: Colors.black),
                    activeIcon: _pngIcon('assets/icons/doctor.png', color: Colors.green),
                    label: 'Bác sĩ',
                  ),
                  BottomNavigationBarItem(
                    icon: _pngIcon('assets/icons/patient.png', color: Colors.black),
                    activeIcon: _pngIcon('assets/icons/patient.png', color: Colors.green),
                    label: 'Bệnh nhân',
                  ),
                  BottomNavigationBarItem(
                    icon: _pngIcon('assets/icons/calendar.png', color: Colors.black),
                    activeIcon: _pngIcon('assets/icons/calendar.png', color: Colors.green),
                    label: 'Lịch hẹn',
                  ),
                  BottomNavigationBarItem(
                    icon: _pngIcon('assets/icons/profile.png', color: Colors.black),
                    activeIcon: _pngIcon('assets/icons/profile.png', color: Colors.green),
                    label: 'Hồ sơ',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Thẻ thống kê (dùng icon PNG)
  Widget _buildStatCard(
    BuildContext context,{
    required String iconPath,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 164.67,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon + Text
            Row(
              children: [
                _pngIcon(iconPath, size: 58),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Khối xanh bên phải
            Container(
              height: 90,
              width: 81,
              decoration: BoxDecoration(
                color: const Color(0xFF0A58FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _pngIcon('assets/icons/chart.png', size: 42.66, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
