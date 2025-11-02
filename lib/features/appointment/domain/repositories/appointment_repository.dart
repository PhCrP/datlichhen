import '../entities/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<void> createAppointment(Appointment appointment);
  Future<void> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(String id);
  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId);
  Future<List<Appointment>> getAppointmentsByPatient(String patientId);
}
