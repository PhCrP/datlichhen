import 'package:datlichhen/features/doctor/domain/repositories/doctor_repository.dart';

/// ❌ UseCase: Xóa một bác sĩ khỏi Firestore
class DeleteDoctor {
  final DoctorRepository repository;

  DeleteDoctor(this.repository);

  Future<void> call(String id) async {
    await repository.deleteDoctor(id);
  }
}
