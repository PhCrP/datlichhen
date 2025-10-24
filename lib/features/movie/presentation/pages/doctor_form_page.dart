import 'package:flutter/material.dart';
import 'package:datlichhen/features/movie/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/movie/domain/usecases/create_doctor_usecase.dart';
import 'package:datlichhen/features/movie/domain/usecases/update_doctor_usecase.dart';
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
  late String _hoTen;
  late String _sdt;
  late String _chuyenKhoa;
  late int _year;
  late String _imgUrl;

  final _chuyenKhoas = ['Khoa tổng quát', 'Nhi', 'Sản', 'Ngoại', 'Tim mạch'];

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;
    _hoTen = d?.hoTen ?? '';
    _sdt = d?.sdt ?? '';
    _chuyenKhoa = d?.chuyenKhoa ?? _chuyenKhoas.first;
    _year = d?.year ?? DateTime.now().year;
    _imgUrl = d?.imgUrl ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final doctor = Doctor(
      documentId: widget.doctor?.documentId ?? '',
      userId: widget.doctor?.userId ?? 'unknown',
      hoTen: _hoTen,
      sdt: _sdt,
      chuyenKhoa: _chuyenKhoa,
      year: _year,
      imgUrl: _imgUrl,
      createdAt: widget.doctor?.createdAt ?? DateTime.now(),
    );

    if (widget.doctor == null) {
      await widget.addUseCase(doctor);
    } else {
      await widget.updateUseCase(doctor);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.doctor != null;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          isEdit ? '✏️ Cập nhật bác sĩ' : '➕ Thêm bác sĩ mới',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color.primaryContainer,
        foregroundColor: color.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 🖼 Ảnh bác sĩ preview
                  GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                        image: _imgUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(_imgUrl),
                                fit: BoxFit.cover,
                                onError: (_, __) {},
                              )
                            : null,
                      ),
                      child: _imgUrl.isEmpty
                          ? const Center(
                              child: Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.grey),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 👤 Họ tên
                  TextFormField(
                    initialValue: _hoTen,
                    decoration: _input('Họ và tên (ví dụ: Bn. Nguyễn Văn A)', Icons.person),
                    validator: (v) =>
                        v!.isEmpty ? 'Vui lòng nhập họ và tên bác sĩ' : null,
                    onSaved: (v) => _hoTen = v!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // 📞 Số điện thoại
                  TextFormField(
                    initialValue: _sdt,
                    decoration: _input('Số điện thoại', Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      final val = v?.trim() ?? '';
                      if (val.isEmpty) return 'Vui lòng nhập số điện thoại';
                      if (val.length < 7) return 'Số điện thoại không hợp lệ';
                      return null;
                    },
                    onSaved: (v) => _sdt = v!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // 🩺 Chuyên khoa
                  DropdownButtonFormField<String>(
                    value: _chuyenKhoa,
                    decoration: _input('Chuyên khoa', Icons.medical_services),
                    items: _chuyenKhoas
                        .map((g) =>
                            DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => _chuyenKhoa = v!),
                  ),
                  const SizedBox(height: 16),

                  // 📅 Year (năm thêm)
                  TextFormField(
                    initialValue: _year.toString(),
                    decoration:
                        _input('Năm (dùng để sắp xếp, ví dụ 2025)', Icons.calendar_month),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final y = int.tryParse(v ?? '');
                      if (y == null || y < 1900 || y > DateTime.now().year + 1) {
                        return 'Năm không hợp lệ';
                      }
                      return null;
                    },
                    onSaved: (v) => _year = int.parse(v!.trim()),
                  ),
                  const SizedBox(height: 16),

                  // 🌆 Img URL
                  TextFormField(
                    initialValue: _imgUrl,
                    decoration: _input('URL ảnh bác sĩ', Icons.image_outlined),
                    onChanged: (v) => setState(() => _imgUrl = v.trim()),
                    onSaved: (v) => _imgUrl = v!.trim(),
                  ),
                  const SizedBox(height: 15),

                  // ✅ Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
                      label: Text(
                        isEdit ? 'Cập nhật bác sĩ' : 'Thêm bác sĩ',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 Input Decoration Helper
  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
