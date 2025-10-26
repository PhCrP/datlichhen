import 'package:flutter/material.dart';
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.pop(context); // đóng dialog
              },
              child: const Text("OK",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Quản lý bác sĩ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      // Body chính
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút "Thêm bác sĩ"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff007AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text(
                  'Thêm bác sĩ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Ô tìm kiếm
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm bác sĩ...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
                _search();
              },
            ),
            const SizedBox(height: 16),

            // Danh sách bác sĩ
            Expanded(
              child: _doctors.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có bác sĩ nào!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _doctors[index];
                        return _buildDoctorCard(doctor);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thẻ bác sĩ
  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ảnh bác sĩ
            CircleAvatar(
              radius: 30,
              backgroundImage: doctor.imgUrl.isNotEmpty
                  ? NetworkImage(doctor.imgUrl)
                  : const AssetImage('assets/images/default_doctor.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 12),

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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chuyên khoa: ${doctor.chuyenKhoa}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  Text(
                    'SĐT: ${doctor.sdt}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),

            // Nút Sửa và Xóa
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _roundedButton(
                  text: "Cập nhật",
                  color: Colors.grey.shade400,
                  onPressed: () => _openForm(doctor),
                ),
                const SizedBox(height: 8),
                _roundedButton(
                  text: "Xóa",
                  color: Colors.redAccent,
                  onPressed: () => _delete(doctor.documentId),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Nút Sửa / Xóa
  Widget _roundedButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minimumSize: const Size(125, 40),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }
}
