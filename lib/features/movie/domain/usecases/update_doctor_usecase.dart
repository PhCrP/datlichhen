import 'package:datlichhen/features/movie/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/doctor_repository.dart';

/// ✏️ UseCase: Cập nhật thông tin bác sĩ trong Firestore
class UpdateDoctor {
  final DoctorRepository repository;

  UpdateDoctor(this.repository);

  Future<void> call(Doctor doctor) async {
    await repository.updateDoctor(doctor);
  }
}
