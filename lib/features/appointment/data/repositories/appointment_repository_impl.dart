import 'package:datlichhen/features/appointment/domain/entities/appointment_entity.dart';
import 'package:datlichhen/features/appointment/domain/repositories/appointment_repository.dart';
import 'package:datlichhen/features/appointment/data/models/appointment_model.dart';
import 'package:datlichhen/features/appointment/data/datasources/appointment_remote_datasource.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentRemoteDataSource remote;

  AppointmentRepositoryImpl(this.remote);

  @override
  Future<void> createAppointment(Appointment appointment) async {
    await remote.add(AppointmentModel.fromEntity(appointment));
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    await remote.update(AppointmentModel.fromEntity(appointment));
  }

  @override
  Future<void> deleteAppointment(String id) async {
    await remote.delete(id);
  }

  @override
  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId) async {
    return await remote.getByDoctor(doctorId);
  }

  @override
  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    return await remote.getByPatient(patientId);
  }
}
