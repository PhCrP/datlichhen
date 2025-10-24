import 'package:datlichhen/features/movie/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/doctor_repository.dart';

/// 🎬 UseCase: Lấy danh sách tất cả bác sĩ từ Firestore
class GetAllDoctors {
  final DoctorRepository repository;

  GetAllDoctors(this.repository);

  Future<List<Doctor>> call() => repository.getDoctors();
}
