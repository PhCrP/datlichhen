import 'package:flutter/material.dart';
import 'package:datlichhen/features/doctor/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/doctor/domain/usecases/create_doctor_usecase.dart';
import 'package:datlichhen/features/doctor/domain/usecases/update_doctor_usecase.dart';

class DoctorFormPage extends StatefulWidget {
  final Doctor? doctor;
  final AddDoctor addUseCase;
  final UpdateDoctor updateUseCase;

  const DoctorFormPage({
    super.key,
    this.doctor,
    required this.addUseCase,
    required this.updateUseCase,
  });

  @override
  State<DoctorFormPage> createState() => _DoctorFormPageState();
}

class _DoctorFormPageState extends State<DoctorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _chuyenKhoaController = TextEditingController();

  String _imgUrl = '';

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;
    if (d != null) {
      _nameController.text = d.hoTen;
      _phoneController.text = d.sdt;
      _chuyenKhoaController.text = d.chuyenKhoa;
      _imgUrl = d.imgUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _chuyenKhoaController.dispose();
    super.dispose();
  }

  /// ✅ Hiển thị popup thành công sau khi lưu
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
                Navigator.pop(context, true); // quay lại trang danh sách
              },
              child: const Text("OK",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  /// ✅ Validate logic
  bool _validateForm() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final chuyenKhoa = _chuyenKhoaController.text.trim();

    if (name.isEmpty) {
      _showError("Vui lòng nhập họ và tên bác sĩ");
      return false;
    }
    if (phone.isEmpty) {
      _showError("Vui lòng nhập số điện thoại");
      return false;
    }
    if (!RegExp(r'^(0[0-9]{9,10})$').hasMatch(phone)) {
      _showError("Số điện thoại không hợp lệ (phải bắt đầu bằng 0)");
      return false;
    }
    if (chuyenKhoa.isEmpty) {
      _showError("Vui lòng nhập chuyên khoa");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 15)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _saveDoctor() async {
    if (!_validateForm()) return;

    final now = DateTime.now();

    final doctor = Doctor(
      documentId: widget.doctor?.documentId ?? '',
      userId: widget.doctor?.userId ?? 'unknown',
      hoTen: _nameController.text.trim(),
      sdt: _phoneController.text.trim(),
      chuyenKhoa: _chuyenKhoaController.text.trim(),
      imgUrl: _imgUrl,
      year: widget.doctor?.year ?? now.year,
      createdAt: widget.doctor?.createdAt ?? now,
    );

    if (widget.doctor == null) {
      await widget.addUseCase(doctor);
      _showSuccessDialog("Thêm bác sĩ thành công", "Dữ liệu đã được lưu");
    } else {
      await widget.updateUseCase(doctor);
      _showSuccessDialog("Cập nhật bác sĩ thành công", "Dữ liệu đã được cập nhật");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.doctor != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          isEdit ? "Cập nhật bác sĩ" : "Thêm bác sĩ",
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 Họ tên bác sĩ
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Họ và tên bác sĩ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Nguyễn Văn A",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 📞 Số điện thoại
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Số điện thoại",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "0909090909",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 🩺 Chuyên khoa
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Chuyên khoa",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _chuyenKhoaController,
                decoration: const InputDecoration(
                  hintText: "VD: Nội tổng hợp",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),

              // 🖼 Upload ảnh (chưa xử lý chức năng upload thực tế)
              // 🖼 Ảnh upload
              GestureDetector(
                onTap: () {
                  // TODO: Chức năng chọn ảnh hoặc chụp ảnh
                },
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imgUrl != null && _imgUrl!.isNotEmpty
                              ? NetworkImage(_imgUrl!)
                              : null,
                          child: _imgUrl == null || _imgUrl!.isEmpty
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.grey)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.photo_camera_outlined,
                              size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tải ảnh lên / Chụp ảnh',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              const SizedBox(height: 35),

              // ✅ Nút lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveDoctor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    isEdit ? "Cập nhật bác sĩ" : "Lưu bác sĩ",
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
