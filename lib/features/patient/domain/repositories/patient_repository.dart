import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';

/// 🔹 Repository trừu tượng cho tính năng quản lý bệnh nhân.
/// Định nghĩa các hành động CRUD + lọc, tìm kiếm.
abstract class PatientRepository {
  /// 📥 Lấy danh sách tất cả bệnh nhân (Firestore)
  Future<List<Patient>> getPatients();

  /// 📄 Lấy thông tin chi tiết của một bệnh nhân theo ID
  Future<Patient> getPatient(String id);

  /// ➕ Thêm bệnh nhân mới
  Future<void> createPatient(Patient patient);

  /// ✏️ Cập nhật thông tin bệnh nhân
  Future<void> updatePatient(Patient patient);

  /// ❌ Xóa bệnh nhân theo ID
  Future<void> deletePatient(String id);

  /// 🔍 Lọc và tìm kiếm bệnh nhân theo trường (name, phone, symptom, ...)
  Future<List<Patient>> getPatientsByField(String field, String query);
}
