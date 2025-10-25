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
  String _selectedChuyenKhoa = "Tất cả";

  final _searchController = TextEditingController();
  final _chuyenKhoas = ["Tất cả", "Khoa tổng quát", "Nhi", "Sản", "Ngoại", "Tim mạch"];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    final doctors = await _getAllDoctors();
    doctors.sort((a, b) => b.year.compareTo(a.year)); // mới nhất trước
    setState(() => _doctors = doctors);
  }

  Future<void> _search() async {
    if (_searchQuery.isEmpty && _selectedChuyenKhoa == "Tất cả") {
      _loadDoctors();
    } else {
      // Nếu filter chọn "Tất cả" mà có query, tìm theo HoTen và SDT (kết hợp)
      if (_selectedChuyenKhoa == "Tất cả") {
        // tìm theo HoTen
        final byName = await _searchDoctors('HoTen', _searchQuery);
        // tìm theo SDT
        final byPhone = await _searchDoctors('SDT', _searchQuery);
        // hợp nhất kết quả (loại id trùng)
        final map = <String, Doctor>{};
        for (var d in byName) map[d.documentId] = d;
        for (var d in byPhone) map[d.documentId] = d;
        final results = map.values.toList();
        results.sort((a, b) => b.year.compareTo(a.year));
        setState(() => _doctors = results);
      } else {
        // Tìm theo chuyên khoa kết hợp query trên một field (ví dụ tìm tên)
        final results = await _searchDoctors('ChuyenKhoa', _selectedChuyenKhoa);
        // Nếu có query thêm, filter trên tên/SDT client-side
        final filtered = results.where((d) {
          final q = _searchQuery.toLowerCase();
          return d.hoTen.toLowerCase().contains(q) ||
              d.sdt.toLowerCase().contains(q);
        }).toList();
        filtered.sort((a, b) => b.year.compareTo(a.year));
        setState(() => _doctors = filtered);
      }
    }
  }

  Future<void> _delete(String id) async {
    await _deleteDoctor(id);
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
        elevation: 2,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '🩺 Quản lý bác sĩ - 3Care',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            color: Colors.deepPurple.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "🔎 Tìm theo tên hoặc số điện thoại...",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value.trim());
                          _search();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedChuyenKhoa,
                        items: _chuyenKhoas
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedChuyenKhoa = v!);
                          _search();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: _doctors.isEmpty
                ? const Center(
                    child: Text(
                      'Không có bác sĩ nào!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadDoctors,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2,
                      ),
                      itemCount: _doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _doctors[index];
                        return GestureDetector(
                          onTap: () => _showDoctorDetail(doctor),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [

                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    doctor.imgUrl,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),

                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(16)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Bn. ${doctor.hoTen}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 4)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${doctor.chuyenKhoa} • ${doctor.sdt}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),

                              Positioned(
                                top: 6,
                                right: 6,
                                child: Row(
                                  children: [
                                    _circleBtn(
                                      icon: Icons.edit,
                                      color: Colors.orangeAccent,
                                      onTap: () => _openForm(doctor),
                                    ),
                                    const SizedBox(width: 6),
                                    _circleBtn(
                                      icon: Icons.delete,
                                      color: Colors.redAccent,
                                      onTap: () => _delete(doctor.documentId),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _circleBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  void _showDoctorDetail(Doctor doctor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bn. ${doctor.hoTen}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("SĐT: ${doctor.sdt}"),
            Text("Chuyên khoa: ${doctor.chuyenKhoa}"),
            Text("Năm thêm: ${doctor.year}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    _openForm(doctor);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Chỉnh sửa"),
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _delete(doctor.documentId);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Xóa"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
