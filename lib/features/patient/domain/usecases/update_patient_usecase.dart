import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/domain/repositories/patient_repository.dart';

/// ✏️ UseCase: Cập nhật thông tin bệnh nhân trong Firestore
class UpdatePatient {
  final PatientRepository repository;

  UpdatePatient(this.repository);

  Future<void> call(Patient patient) async {
    await repository.updatePatient(patient);
  }
}
