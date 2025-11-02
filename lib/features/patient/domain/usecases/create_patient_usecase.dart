import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/domain/repositories/patient_repository.dart';

/// 🟢 UseCase: Thêm một bệnh nhân mới vào Firestore
class AddPatient {
  final PatientRepository repository;

  AddPatient(this.repository);

  Future<void> call(Patient patient) {
    return repository.createPatient(patient);
  }
}
