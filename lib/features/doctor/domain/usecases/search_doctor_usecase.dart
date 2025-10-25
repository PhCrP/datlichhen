import 'package:datlichhen/features/doctor/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/doctor/domain/repositories/doctor_repository.dart';

/// 🔍 UseCase: Lọc & tìm kiếm bác sĩ theo field và từ khóa
class GetDoctorsByField {
  final DoctorRepository repository;

  GetDoctorsByField(this.repository);

  Future<List<Doctor>> call(String field, String query) =>
      repository.getDoctorsByField(field, query);
}
