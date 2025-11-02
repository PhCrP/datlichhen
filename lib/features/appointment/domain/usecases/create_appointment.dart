import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class CreateAppointment {
  final AppointmentRepository repository;

  CreateAppointment(this.repository);

  Future<void> call(Appointment appointment) async {
    await repository.createAppointment(appointment);
  }
}
