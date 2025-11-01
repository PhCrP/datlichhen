import 'package:flutter/material.dart';
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
              onPressed: () {
                Navigator.pop(context);
              },
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

  Future<void> _loadPatients() async {
    final patients = await _getAllPatients();
    setState(() => _patients = patients);
  }

  Future<void> _search() async {
    if (_searchQuery.isEmpty) {
      _loadPatients();
      return;
    }
    // 🔎 Tìm theo tên và số điện thoại
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
          'Quản lý bệnh nhân',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút "Thêm bệnh nhân"
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
                  'Thêm bệnh nhân',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Ô tìm kiếm
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm bệnh nhân...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
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

            // Danh sách bệnh nhân
            Expanded(
              child: _patients.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có bệnh nhân nào!',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        final patient = _patients[index];
                        return _buildPatientCard(patient);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thẻ bệnh nhân
  Widget _buildPatientCard(Patient patient) {
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
            // Icon đại diện bệnh nhân
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/default_patient.png'),
            ),
            const SizedBox(width: 12),

            // Thông tin bệnh nhân
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giới tính: ${patient.gender}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  Text(
                    'SĐT: ${patient.phone}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  Text(
                    'Triệu chứng: ${patient.symptom}',
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
                  onPressed: () => _openForm(patient),
                ),
                const SizedBox(height: 8),
                _roundedButton(
                  text: "Xóa",
                  color: Colors.redAccent,
                  onPressed: () => _delete(patient.documentId),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minimumSize: const Size(125, 40),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
