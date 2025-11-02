import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/domain/repositories/patient_repository.dart';

/// 🎬 UseCase: Lấy danh sách tất cả bệnh nhân từ Firestore
class GetAllPatients {
  final PatientRepository repository;

  GetAllPatients(this.repository);

  Future<List<Patient>> call() => repository.getPatients();
}
