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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _symptomController = TextEditingController();
  DateTime? _birthdate;
  String _gender = "Nam";

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

  /// ✅ Hiển thị popup thành công
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

  /// ❌ Hiển thị lỗi
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

  /// ✅ Validate dữ liệu đầu vào
  bool _validateForm() {
    if (_nameController.text.trim().isEmpty) {
      _showError("Vui lòng nhập họ và tên bệnh nhân");
      return false;
    }
    if (_birthdate == null) {
      _showError("Vui lòng chọn ngày sinh");
      return false;
    }
    if (_gender.isEmpty) {
      _showError("Vui lòng chọn giới tính");
      return false;
    }
    if (_phoneController.text.trim().isNotEmpty &&
        !RegExp(r'^(0[0-9]{9,10})$').hasMatch(_phoneController.text.trim())) {
      _showError("Số điện thoại không hợp lệ");
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

  /// 💾 Lưu bệnh nhân (Thêm / Cập nhật)
  Future<void> _savePatient() async {
    if (!_validateForm()) {
      return;
    }

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
    } catch (e, stack) {}
  }

  /// 📅 Chọn ngày sinh
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          isEdit ? "Cập nhật bệnh nhân" : "Thêm bệnh nhân",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 Họ tên
              _buildLabel("Họ và tên bệnh nhân"),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Nguyễn Văn A",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 📅 Ngày sinh
              _buildLabel("Ngày sinh"),
              GestureDetector(
                onTap: _pickBirthDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black26)),
                  ),
                  child: Text(
                    _birthdate == null
                        ? "Chọn ngày sinh"
                        : "${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}",
                    style: TextStyle(
                      fontSize: 16,
                      color: _birthdate == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🚻 Giới tính
              _buildLabel("Giới tính"),
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
              const SizedBox(height: 20),

              // 📞 Số điện thoại
              _buildLabel("Số điện thoại"),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "0909090909",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 🏠 Địa chỉ
              _buildLabel("Địa chỉ"),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: "VD: 123 Đường ABC, Quận 1",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 🤒 Triệu chứng
              _buildLabel("Triệu chứng"),
              TextField(
                controller: _symptomController,
                decoration: const InputDecoration(
                  hintText: "VD: Ho, sốt, đau họng...",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),

              // ✅ Nút lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _savePatient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isEdit ? "Cập nhật bệnh nhân" : "Lưu bệnh nhân",
                    style: const TextStyle(
                      fontSize: 17,
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

  /// 🧩 Widget nhãn tiêu đề nhỏ
  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
