import 'package:datlichhen/features/patient/domain/repositories/patient_repository.dart';

/// ❌ UseCase: Xóa một bệnh nhân khỏi Firestore
class DeletePatient {
  final PatientRepository repository;

  DeletePatient(this.repository);

  Future<void> call(String id) async {
    await repository.deletePatient(id);
  }
}
