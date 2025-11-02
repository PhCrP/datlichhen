import 'package:datlichhen/features/patient/data/datasources/patient_remote_datasource.dart';
import 'package:datlichhen/features/patient/data/models/patient_model.dart';
import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/domain/repositories/patient_repository.dart';

/// 💾 Triển khai repository cho quản lý bệnh nhân (Firestore)
class PatientRepositoryImpl extends PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepositoryImpl(this.remoteDataSource);

  /// ➕ Thêm bệnh nhân mới
  @override
  Future<void> createPatient(Patient patient) async {
    final model = PatientModel.fromEntity(patient);
    await remoteDataSource.add(model);
  }

  /// ❌ Xóa bệnh nhân theo ID
  @override
  Future<void> deletePatient(String id) async {
    await remoteDataSource.delete(id);
  }

  /// 📄 Lấy thông tin chi tiết bệnh nhân theo ID
  @override
  Future<Patient> getPatient(String id) async {
    final model = await remoteDataSource.getPatient(id);
    if (model == null) {
      throw Exception('Patient not found');
    }
    return model;
  }

  /// 📋 Lấy danh sách tất cả bệnh nhân
  @override
  Future<List<Patient>> getPatients() async {
    final models = await remoteDataSource.getAll();
    return models;
  }

  /// ✏️ Cập nhật thông tin bệnh nhân
  @override
  Future<void> updatePatient(Patient patient) async {
    final model = PatientModel.fromEntity(patient);
    await remoteDataSource.update(model);
  }

  /// 🔍 Tìm kiếm bệnh nhân theo field và từ khóa
  @override
  Future<List<Patient>> getPatientsByField(String field, String query) async {
    final patients = await remoteDataSource.getPatientsByField(field, query);
    return patients;
  }
}
