import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:datlichhen/core/routing/app_routes.dart';

class AppointmentListPage extends StatefulWidget {
  const AppointmentListPage({super.key});

  @override
  State<AppointmentListPage> createState() => _AppointmentListPageState();
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  int _currentIndex = 3;
  final _searchController = TextEditingController();
  String _searchQuery = "";

  // 🔹 Dữ liệu tượng trưng
  final List<Map<String, String>> _appointments = [
    {
      'id': '1',
      'doctor': 'Nguyễn Văn A',
      'patient': 'Trần Thị B',
      'time': '09:30, 31/10/2025',
      'status': 'Chờ xác nhận',
    },
    {
      'id': '2',
      'doctor': 'Lê Văn C',
      'patient': 'Ngô Đức D',
      'time': '14:00, 01/11/2025',
      'status': 'Đã xác nhận',
    },
  ];

  // 🔹 Hàm xóa tượng trưng
  void _deleteAppointment(String id) {
    setState(() => _appointments.removeWhere((a) => a['id'] == id));
    _showDialog("Xóa lịch hẹn thành công", "Dữ liệu đã được cập nhật");
  }

  // 🔹 Dialog thông báo
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            Text(
              content,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Hàm build giao diện từng thẻ lịch hẹn
  // 🔹 Hàm build giao diện từng thẻ lịch hẹn (đã chỉnh sửa)
  Widget _buildAppointmentCard(Map<String, String> appt) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ), // ✅ Cách đều 2 rìa
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dòng thông tin bác sĩ - bệnh nhân
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(
                    'assets/images/default_doctor.png',
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bác sĩ: ${appt['doctor']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Bệnh nhân: ${appt['patient']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Thời gian: ${appt['time']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Trạng thái: ${appt['status']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Hai nút hành động cách đều rìa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ✅ Nút cập nhật
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        // mở form cập nhật lịch hẹn
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA4AAAE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Cập nhật",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // ✅ Nút xóa
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () => _deleteAppointment(appt['id']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE90C0C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Xóa",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Hàm build thanh bottom nav
  Widget _buildBottomNavBar() {
    const itemCount = 5;
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
          final itemWidth = constraints.maxWidth / itemCount;
          final indicatorWidth = _currentIndex == 0 ? 25 : 35;
          final indicatorLeft =
              _currentIndex * itemWidth + (itemWidth - indicatorWidth) / 2;

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                top: 0,
                left: indicatorLeft,
                child: Container(
                  width: indicatorWidth.toDouble(),
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.black,
                  onTap: (index) {
                    setState(() => _currentIndex = index);
                    if (index == 0) context.push(AppRoutes.home);
                    if (index == 1) context.push(AppRoutes.doctor);
                    if (index == 2) context.push(AppRoutes.patient);
                    if (index == 3) context.push(AppRoutes.appointment);
                    if (index == 4) context.push(AppRoutes.profile);
                  },
                  items: [
                    _navItem('assets/icons/home.png', 'Trang chủ'),
                    _navItem('assets/icons/doctor.png', 'Bác sĩ'),
                    _navItem('assets/icons/patient.png', 'Bệnh nhân'),
                    _navItem('assets/icons/calendar.png', 'Lịch hẹn'),
                    _navItem('assets/icons/profile.png', 'Hồ sơ'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _navItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(iconPath, width: 24, height: 24, color: Colors.black),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(height: 43.27, color: const Color(0xFF43B02A)),

          // AppBar trắng
          Container(
            height: 95,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Quản lý lịch hẹn',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Thêm + tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // mở form thêm lịch hẹn
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "Thêm lịch hẹn",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Tìm lịch hẹn...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Khối danh sách
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 515,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListView.builder(
                  itemCount: _appointments.length,
                  itemBuilder: (_, i) =>
                      _buildAppointmentCard(_appointments[i]),
                ),
              ),
            ),
          ),

          _buildBottomNavBar(),
        ],
      ),
    );
  }
}
