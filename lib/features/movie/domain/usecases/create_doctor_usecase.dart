import 'package:datlichhen/features/movie/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/doctor_repository.dart';

/// 🟢 UseCase: Thêm một bác sĩ mới vào Firestore
class AddDoctor {
  final DoctorRepository repository;

  AddDoctor(this.repository);

  Future<void> call(Doctor doctor) {
    return repository.createDoctor(doctor);
  }
}
