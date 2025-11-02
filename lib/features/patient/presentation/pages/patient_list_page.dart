import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:datlichhen/core/routing/app_routes.dart';
import 'patient_form_page.dart';
import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/data/datasources/patient_remote_datasource.dart';
import 'package:datlichhen/features/patient/data/repositories/patient_repository_impl.dart';
import 'package:datlichhen/features/patient/domain/usecases/get_all_patient.dart';
import 'package:datlichhen/features/patient/domain/usecases/create_patient_usecase.dart';
import 'package:datlichhen/features/patient/domain/usecases/update_patient_usecase.dart';
import 'package:datlichhen/features/patient/domain/usecases/delete_patient_usecase.dart';
import 'package:datlichhen/features/patient/domain/usecases/search_patient_usecase.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  int _currentIndex = 2;

  late final _remote = PatientRemoteDataSourceImpl();
  late final _repo = PatientRepositoryImpl(_remote);

  late final _getAllPatients = GetAllPatients(_repo);
  late final _addPatient = AddPatient(_repo);
  late final _updatePatient = UpdatePatient(_repo);
  late final _deletePatient = DeletePatient(_repo);
  late final _searchPatients = GetPatientsByField(_repo);

  List<Patient> _patients = [];
  String _searchQuery = "";

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final patients = await _getAllPatients();
    setState(() => _patients = patients);
  }

  Future<void> _search() async {
    if (_searchQuery.isEmpty) {
      _loadPatients();
      return;
    }
    final byName = await _searchPatients('name', _searchQuery);
    final byPhone = await _searchPatients('phone', _searchQuery);
    final map = <String, Patient>{};
    for (var p in byName) map[p.documentId] = p;
    for (var p in byPhone) map[p.documentId] = p;
    setState(() => _patients = map.values.toList());
  }

  Future<void> _delete(String id) async {
    await _deletePatient(id);
    _showSuccessDialog("Xóa bệnh nhân thành công", "Dữ liệu đã được cập nhật");
    await _loadPatients();
  }

  Future<void> _openForm([Patient? patient]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatientFormPage(
          patient: patient,
          addUseCase: _addPatient,
          updateUseCase: _updatePatient,
        ),
      ),
    );
    if (result == true) _loadPatients();
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
              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    'Quản lý bệnh nhân',
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

          // ✅ Nút thêm + tìm kiếm nằm ngoài
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Thêm bệnh nhân',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm bệnh nhân...',
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
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

          // ✅ Khối danh sách
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 515,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(16),
                child: _patients.isEmpty
                    ? const Center(
                        child: Text(
                          'Không có bệnh nhân nào!',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _patients.length,
                        itemBuilder: (context, index) {
                          return _buildPatientCard(_patients[index]);
                        },
                      ),
              ),
            ),
          ),

          // ✅ Bottom navigation bar
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
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
          // Hàng thông tin
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(
                  'assets/images/default_patient.png',
                ),
              ),
              const SizedBox(width: 14),

              // Thông tin bệnh nhân
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BN. ${patient.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Giới tính: ${patient.gender}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'SĐT: ${patient.phone}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Triệu chứng: ${patient.symptom}',
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

          // 🔹 Hai nút Cập nhật & Xóa
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => _openForm(patient),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA4AAAE),
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
              SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => _delete(patient.documentId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE90C0C),
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
            if (index == 2) context.push(AppRoutes.patient);
            if (index == 3) context.push(AppRoutes.appointment);
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
}
