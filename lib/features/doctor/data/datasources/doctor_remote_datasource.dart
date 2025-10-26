import 'package:datlichhen/core/data/firebase_remote_datasource.dart';
import 'package:datlichhen/features/doctor/data/models/doctor_model.dart';

/// 🔹 Interface định nghĩa các hành động với Firestore cho Doctor
abstract class DoctorRemoteDataSource {
  Future<List<DoctorModel>> getAll();
  Future<DoctorModel?> getDoctor(String id);
  Future<void> add(DoctorModel doctor);
  Future<void> update(DoctorModel doctor);
  Future<void> delete(String id);
  Future<List<DoctorModel>> getDoctorsByField(String field, String query);
}

/// 🔹 Triển khai cụ thể bằng Firestore thông qua FirebaseRemoteDS
class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final FirebaseRemoteDS<DoctorModel> _remoteSource;

  DoctorRemoteDataSourceImpl()
    : _remoteSource = FirebaseRemoteDS<DoctorModel>(
        collectionName: 'doctors', // **collection đổi thành 'doctors'**
        fromFirestore: (doc) => DoctorModel.fromFirestore(doc),
        toFirestore: (model) => model.toJson(),
      );

  @override
  Future<List<DoctorModel>> getAll() async {
    final doctors = await _remoteSource.getAll();
    return doctors;
  }

  @override
  Future<DoctorModel?> getDoctor(String id) async {
    final doctor = await _remoteSource.getById(id);
    return doctor;
  }

  @override
  Future<void> add(DoctorModel doctor) async {
    await _remoteSource.add(doctor);
  }

  @override
  Future<void> update(DoctorModel doctor) async {
    await _remoteSource.update(doctor.documentId, doctor);
  }

  @override
  Future<void> delete(String id) async {
    await _remoteSource.delete(id);
  }

  @override
  Future<List<DoctorModel>> getDoctorsByField(String field, String query) async {
    final doctors = await _remoteSource.searchByField(field, query);
    return doctors;
  }
}
