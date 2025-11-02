import 'package:datlichhen/core/routing/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.error, size: 20, color: Colors.red),
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
                        icon: _pngIcon(
                          'assets/icons/notification.png',
                          size: 26,
                        ),
                        onPressed: () => context.push(AppRoutes.notification),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: _pngIcon('assets/icons/menu.png', size: 28.5),
                        onPressed: () async {
                          final selected = await showMenu<String>(
                            context: context,
                            position: const RelativeRect.fromLTRB(
                              1000,
                              80,
                              10,
                              0,
                            ), // vị trí hiển thị menu
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            items: [
                              PopupMenuItem<String>(
                                value: 'profile',
                                child: Row(
                                  children: [
                                    _pngIcon(
                                      'assets/images/profile.png',
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('Hồ sơ'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    _pngIcon(
                                      'assets/images/settings.png',
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('Cài đặt'),
                                  ],
                                ),
                              ),
                              PopupMenuDivider(height: 8),
                              PopupMenuItem<String>(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    _pngIcon(
                                      'assets/images/logout.png',
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Đăng xuất',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );

                          // 🔹 Xử lý hành động khi chọn menu
                          switch (selected) {
                            case 'profile':
                              context.push(
                                AppRoutes.notification,
                              ); // ví dụ mở hồ sơ
                              break;
                            case 'settings':
                              // TODO: mở trang cài đặt
                              break;
                            case 'logout':
                              await FirebaseAuth.instance.signOut();
                              if (mounted) context.go(AppRoutes.login);
                              break;
                          }
                        },
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
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
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
                      onTap: () => context.push(AppRoutes.patient),
                    ),
                    _buildStatCard(
                      context,
                      iconPath: 'assets/icons/calendar_2.png',
                      title: "Lịch hẹn",
                      count: 13,
                      onTap: () => context.push(AppRoutes.appointment),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(iconPath, width: 24, height: 24, color: Colors.black),
      label: label,
    );
  }

  Widget _buildBottomNavBar() {
    const int itemCount = 5;

    return Container(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = constraints.maxWidth / itemCount;

          // ✅ Xác định độ rộng vạch xanh theo vị trí
          final double indicatorWidth = _currentIndex == 0
              ? 25
              : 35; // Home ngắn hơn

          // ✅ Căn giữa icon
          final double indicatorLeft =
              _currentIndex * itemWidth + (itemWidth - indicatorWidth) / 2;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              // 🔹 Vạch xanh trên cùng
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: 0,
                left: indicatorLeft,
                child: Container(
                  width: indicatorWidth,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.horizontal(
                      left: _currentIndex == 0
                          ? const Radius.circular(2)
                          : Radius.zero,
                      right: _currentIndex == itemCount - 1
                          ? const Radius.circular(2)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),

              // 🔹 BottomNavigationBar
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    backgroundColor: Colors.white,
                    selectedItemColor: Colors.black,
                    unselectedItemColor: Colors.black,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    onTap: (index) {
                      setState(() => _currentIndex = index);
                      if (index == 0) context.push(AppRoutes.home);
                      if (index == 1) context.push(AppRoutes.doctor);
                      if (index == 2) context.push(AppRoutes.patient);
                      if (index == 3) context.push(AppRoutes.appointment);
                      if (index == 4) context.push(AppRoutes.profile);
                    },
                    items: [
                      _buildNavItem('assets/icons/home.png', 'Trang chủ'),
                      _buildNavItem('assets/icons/doctor.png', 'Bác sĩ'),
                      _buildNavItem('assets/icons/patient.png', 'Bệnh nhân'),
                      _buildNavItem('assets/icons/calendar.png', 'Lịch hẹn'),
                      _buildNavItem('assets/icons/profile.png', 'Hồ sơ'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔹 Thẻ thống kê (dùng icon PNG)
  Widget _buildStatCard(
    BuildContext context, {
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
                child: _pngIcon(
                  'assets/icons/chart.png',
                  size: 42.66,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
