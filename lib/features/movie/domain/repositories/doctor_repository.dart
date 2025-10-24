import 'package:datlichhen/features/movie/domain/entities/doctor_entity.dart';

/// 🔹 Repository trừu tượng cho tính năng quản lý bác sĩ.
/// Định nghĩa các hành động CRUD + lọc, tìm kiếm.
abstract class DoctorRepository {
  /// 📥 Lấy danh sách tất cả bác sĩ (FireStore)
  Future<List<Doctor>> getDoctors();

  /// 📄 Lấy thông tin chi tiết của một bác sĩ theo ID
  Future<Doctor> getDoctor(String id);

  /// ➕ Thêm bác sĩ mới
  Future<void> createDoctor(Doctor doctor);

  /// ✏️ Cập nhật thông tin bác sĩ
  Future<void> updateDoctor(Doctor doctor);

  /// ❌ Xóa bác sĩ theo ID
  Future<void> deleteDoctor(String id);

  /// 🔍 Lọc và tìm kiếm bác sĩ theo field (HoTen, SDT, ChuyenKhoa, ...)
  Future<List<Doctor>> getDoctorsByField(String field, String query);
}
