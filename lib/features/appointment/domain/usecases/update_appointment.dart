import '../entities/appointment_entity.dart';
import '../repositories/appointment_repository.dart';

class UpdateAppointment {
  final AppointmentRepository repository;

  UpdateAppointment(this.repository);

  Future<void> call(Appointment appointment) async {
    await repository.updateAppointment(appointment);
  }
}
