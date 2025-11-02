import 'package:datlichhen/core/data/firebase_remote_datasource.dart';
import 'package:datlichhen/features/patient/data/models/patient_model.dart';

/// 🔹 Interface định nghĩa các hành động với Firestore cho Patient
abstract class PatientRemoteDataSource {
  Future<List<PatientModel>> getAll();
  Future<PatientModel?> getPatient(String id);
  Future<void> add(PatientModel patient);
  Future<void> update(PatientModel patient);
  Future<void> delete(String id);
  Future<List<PatientModel>> getPatientsByField(String field, String query);
}

/// 🔹 Triển khai cụ thể bằng Firestore thông qua FirebaseRemoteDS
class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final FirebaseRemoteDS<PatientModel> _remoteSource;

  PatientRemoteDataSourceImpl()
    : _remoteSource = FirebaseRemoteDS<PatientModel>(
        collectionName: 'patients', // ✅ Đặt collection Firestore là "patients"
        fromFirestore: (doc) => PatientModel.fromFirestore(doc),
        toFirestore: (model) => model.toJson(),
      );

  @override
  Future<List<PatientModel>> getAll() async {
    final patients = await _remoteSource.getAll();
    return patients;
  }

  @override
  Future<PatientModel?> getPatient(String id) async {
    final patient = await _remoteSource.getById(id);
    return patient;
  }

  @override
  Future<void> add(PatientModel patient) async {
    await _remoteSource.add(patient);
  }

  @override
  Future<void> update(PatientModel patient) async {
    await _remoteSource.update(patient.documentId, patient);
  }

  @override
  Future<void> delete(String id) async {
    await _remoteSource.delete(id);
  }

  @override
  Future<List<PatientModel>> getPatientsByField(
    String field,
    String query,
  ) async {
    final patients = await _remoteSource.searchByField(field, query);
    return patients;
  }
}
