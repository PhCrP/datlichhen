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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool _validate() {
    if (_nameController.text.trim().isEmpty) {
      _showError("Vui lòng nhập họ và tên bác sĩ");
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError("Vui lòng nhập số điện thoại");
      return false;
    }
    if (_chuyenKhoaController.text.trim().isEmpty) {
      _showError("Vui lòng nhập chuyên khoa");
      return false;
    }
    return true;
  }

  Future<void> _saveDoctor() async {
    if (!_validate()) return;

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
    } else {
      await widget.updateUseCase(doctor);
    }

    // Quay lại sau khi lưu
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.doctor != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "Cập nhật bác sĩ" : "Thêm bác sĩ",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: ColoredBox(
            color: Color(0xFF32A852), // ✅ Thanh xanh trên cùng (giống figma)
            child: SizedBox(height: 4),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// 🧑‍⚕️ Họ và tên bác sĩ
              const Text(
                "Họ và tên bác sĩ",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Nguyễn Văn A",
                  hintStyle: TextStyle(color: Colors.black38),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// 📞 Số điện thoại
              const Text(
                "Số điện thoại",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "0909090909",
                  hintStyle: TextStyle(color: Colors.black38),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              /// 🩺 Chuyên khoa
              const Text(
                "Chuyên khoa",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _chuyenKhoaController,
                decoration: const InputDecoration(
                  hintText: "VD: Nội tổng hợp",
                  hintStyle: TextStyle(color: Colors.black38),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// 🖼 Ảnh bác sĩ + icon upload
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _imgUrl.isNotEmpty
                              ? NetworkImage(_imgUrl)
                              : null,
                          child: _imgUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 45,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Tải ảnh lên / Chụp ảnh",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              /// 🔵 Nút Lưu bác sĩ
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveDoctor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D99FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? "Cập nhật bác sĩ" : "Lưu bác sĩ",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
