import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:datlichhen/core/routing/app_routes.dart';
import 'doctor_form_page.dart';
import 'package:datlichhen/features/doctor/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/doctor/data/datasources/doctor_remote_datasource.dart';
import 'package:datlichhen/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:datlichhen/features/doctor/domain/usecases/get_all_doctor.dart';
import 'package:datlichhen/features/doctor/domain/usecases/create_doctor_usecase.dart';
import 'package:datlichhen/features/doctor/domain/usecases/update_doctor_usecase.dart';
import 'package:datlichhen/features/doctor/domain/usecases/delete_doctor_usecase.dart';
import 'package:datlichhen/features/doctor/domain/usecases/search_doctor_usecase.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({super.key});

  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  int _currentIndex = 1;

  late final _remote = DoctorRemoteDataSourceImpl();
  late final _repo = DoctorRepositoryImpl(_remote);

  late final _getAllDoctors = GetAllDoctors(_repo);
  late final _addDoctor = AddDoctor(_repo);
  late final _updateDoctor = UpdateDoctor(_repo);
  late final _deleteDoctor = DeleteDoctor(_repo);
  late final _searchDoctors = GetDoctorsByField(_repo);

  List<Doctor> _doctors = [];
  String _searchQuery = "";

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final doctors = await _getAllDoctors();
    setState(() => _doctors = doctors);
  }

  Future<void> _search() async {
    if (_searchQuery.isEmpty) {
      _loadDoctors();
      return;
    }
    final byName = await _searchDoctors('HoTen', _searchQuery);
    final byPhone = await _searchDoctors('SDT', _searchQuery);
    final map = <String, Doctor>{};
    for (var d in byName) map[d.documentId] = d;
    for (var d in byPhone) map[d.documentId] = d;
    setState(() => _doctors = map.values.toList());
  }

  Future<void> _delete(String id) async {
    await _deleteDoctor(id);
    _showSuccessDialog("Xóa bác sĩ thành công", "Dữ liệu đã được cập nhật");
    await _loadDoctors();
  }

  Future<void> _openForm([Doctor? doctor]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorFormPage(
          doctor: doctor,
          addUseCase: _addDoctor,
          updateUseCase: _updateDoctor,
        ),
      ),
    );
    if (result == true) _loadDoctors();
  }

  void _showSuccessDialog(String message, String subMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              subMessage,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.pop(context),
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

  Widget _pngIcon(
    String path, {
    double size = 24,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      path,
      width: size,
      height: size,
      color: color,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.error, color: Colors.red, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Thanh xanh trên cùng
          Container(height: 43.27, color: const Color(0xFF43B02A)),

          // AppBar trắng
          Container(
            height: 95,
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 8,
                right: 8,
                bottom: 0,
              ),
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
                    'Quản lý bác sĩ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // ✅ Khu thêm + tìm kiếm
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _openForm(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Thêm bác sĩ',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm bác sĩ...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.black12,
                        width: 1,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value.trim());
                    _search();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Khối bao danh sách
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 0,
                left: 16,
                right: 16,
                bottom: 0,
              ),
              child: Container(
                height: 515,
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 16,
                  right: 16,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: _doctors.isEmpty
                    ? const Center(
                        child: Text(
                          'Không có bác sĩ nào!',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _doctors.length,
                        itemBuilder: (context, index) {
                          return _buildDoctorCard(_doctors[index]);
                        },
                      ),
              ),
            ),
          ),

          // ✅ Bottom nav bar
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 0) context.push(AppRoutes.home);
            if (index == 1) context.push(AppRoutes.doctor);
          },
          items: [
            BottomNavigationBarItem(
              icon: _pngIcon('assets/icons/home.png', color: Colors.black),
              activeIcon: _pngIcon(
                'assets/icons/home.png',
                color: Colors.green,
              ),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: _pngIcon('assets/icons/doctor.png', color: Colors.black),
              activeIcon: _pngIcon(
                'assets/icons/doctor.png',
                color: Colors.green,
              ),
              label: 'Bác sĩ',
            ),
            BottomNavigationBarItem(
              icon: _pngIcon('assets/icons/patient.png', color: Colors.black),
              activeIcon: _pngIcon(
                'assets/icons/patient.png',
                color: Colors.green,
              ),
              label: 'Bệnh nhân',
            ),
            BottomNavigationBarItem(
              icon: _pngIcon('assets/icons/calendar.png', color: Colors.black),
              activeIcon: _pngIcon(
                'assets/icons/calendar.png',
                color: Colors.green,
              ),
              label: 'Lịch hẹn',
            ),
            BottomNavigationBarItem(
              icon: _pngIcon('assets/icons/profile.png', color: Colors.black),
              activeIcon: _pngIcon(
                'assets/icons/profile.png',
                color: Colors.green,
              ),
              label: 'Hồ sơ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ảnh bác sĩ
              CircleAvatar(
                radius: 32,
                backgroundImage: doctor.imgUrl.isNotEmpty
                    ? NetworkImage(doctor.imgUrl)
                    : const AssetImage('assets/images/default_doctor.png')
                          as ImageProvider,
              ),
              const SizedBox(width: 14),

              // Thông tin bác sĩ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BS. ${doctor.hoTen}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chuyên khoa: ${doctor.chuyenKhoa}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'SĐT: ${doctor.sdt}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 Hai nút Cập nhật & Xóa cách đều rìa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nút Cập nhật
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => _openForm(doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFA4AAAE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: const Text(
                    "Cập nhật",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // Nút Xóa
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => _delete(doctor.documentId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE90C0C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 0,
                  ),
                  child: const Text(
                    "Xóa",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundedButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minimumSize: const Size(125, 40),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
