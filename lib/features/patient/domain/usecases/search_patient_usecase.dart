import 'package:datlichhen/features/patient/domain/entities/patient_entity.dart';
import 'package:datlichhen/features/patient/domain/repositories/patient_repository.dart';

/// 🔍 UseCase: Lọc & tìm kiếm bệnh nhân theo field và từ khóa
class GetPatientsByField {
  final PatientRepository repository;

  GetPatientsByField(this.repository);

  Future<List<Patient>> call(String field, String query) =>
      repository.getPatientsByField(field, query);
}
