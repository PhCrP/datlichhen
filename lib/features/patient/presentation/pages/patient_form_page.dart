import 'package:flutter/material.dart';
import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/domain/usecases/create_patient_usecase.dart';
import 'package:datlichhen/features/patient/domain/usecases/update_patient_usecase.dart';

class PatientFormPage extends StatefulWidget {
  final Patient? patient;
  final AddPatient addUseCase;
  final UpdatePatient updateUseCase;

  const PatientFormPage({
    super.key,
    this.patient,
    required this.addUseCase,
    required this.updateUseCase,
  });

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _symptomController = TextEditingController();
  DateTime? _birthdate;
  String _gender = "Nam";

  String _imgUrl = "";

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    if (p != null) {
      _nameController.text = p.name;
      _phoneController.text = p.phone;
      _addressController.text = p.address;
      _symptomController.text = p.symptom;
      _birthdate = p.birthdate;
      _gender = p.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  // --- Hiển thị thông báo thành công ---
  void _showSuccessDialog(String title, String subtitle) {
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
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
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
                Navigator.pop(context, true);
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

  bool _validate() {
    if (_nameController.text.trim().isEmpty) {
      _showError("Vui lòng nhập họ và tên bệnh nhân");
      return false;
    }
    if (_birthdate == null) {
      _showError("Vui lòng chọn ngày sinh");
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showError("Vui lòng nhập số điện thoại");
      return false;
    }
    if (_addressController.text.trim().isEmpty) {
      _showError("Vui lòng nhập địa chỉ");
      return false;
    }
    if (_symptomController.text.trim().isEmpty) {
      _showError("Vui lòng nhập triệu chứng");
      return false;
    }
    return true;
  }

  Future<void> _savePatient() async {
    if (!_validate()) return;

    final now = DateTime.now();
    final patient = Patient(
      documentId: widget.patient?.documentId ?? '',
      name: _nameController.text.trim(),
      birthdate: _birthdate!,
      gender: _gender,
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      symptom: _symptomController.text.trim(),
      createdAt: widget.patient?.createdAt ?? now,
      updatedAt: now,
    );

    try {
      if (widget.patient == null) {
        await widget.addUseCase(patient);
        _showSuccessDialog("Thêm bệnh nhân thành công", "Dữ liệu đã được lưu");
      } else {
        await widget.updateUseCase(patient);
        _showSuccessDialog(
          "Cập nhật bệnh nhân thành công",
          "Dữ liệu đã được cập nhật",
        );
      }
    } catch (e) {
      _showError("Có lỗi xảy ra, vui lòng thử lại.");
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (date != null) setState(() => _birthdate = date);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.patient != null;

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
          isEdit ? "Cập nhật bệnh nhân" : "Thêm bệnh nhân",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: ColoredBox(
            color: Color(0xFF32A852),
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

              /// 👤 Họ và tên
              const Text(
                "Họ và tên bệnh nhân",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: _inputDecoration("Nguyễn Văn A"),
              ),
              const SizedBox(height: 22),

              /// 📅 Ngày sinh
              const Text(
                "Ngày sinh",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickBirthDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: Text(
                    _birthdate == null
                        ? "Chọn ngày sinh"
                        : "${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}",
                    style: TextStyle(
                      color: _birthdate == null
                          ? Colors.black38
                          : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              /// 🚻 Giới tính
              const Text(
                "Giới tính",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Radio<String>(
                    value: "Nam",
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value!),
                  ),
                  const Text("Nam"),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: "Nữ",
                    groupValue: _gender,
                    onChanged: (value) => setState(() => _gender = value!),
                  ),
                  const Text("Nữ"),
                ],
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
                decoration: _inputDecoration("0901234567"),
              ),
              const SizedBox(height: 22),

              /// 🏠 Địa chỉ
              const Text(
                "Địa chỉ",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _addressController,
                decoration: _inputDecoration("123 Đường ABC, Quận 1"),
              ),
              const SizedBox(height: 22),

              /// 🤒 Triệu chứng
              const Text(
                "Triệu chứng",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _symptomController,
                decoration: _inputDecoration("Ho, sốt, đau họng..."),
              ),

              const SizedBox(height: 30),

              /// 🧍‍♂️ Ảnh đại diện bệnh nhân
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

              /// 🔵 Nút Lưu / Cập nhật
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _savePatient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D99FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? "Cập nhật bệnh nhân" : "Lưu bệnh nhân",
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black38),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }
}
