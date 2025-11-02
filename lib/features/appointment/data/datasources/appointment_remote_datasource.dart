import 'package:datlichhen/core/data/firebase_remote_datasource.dart';
import 'package:datlichhen/features/appointment/data/models/appointment_model.dart';

abstract class AppointmentRemoteDataSource {
  Future<void> add(AppointmentModel appointment);
  Future<void> update(AppointmentModel appointment);
  Future<void> delete(String id);
  Future<AppointmentModel?> getById(String id);
  Future<List<AppointmentModel>> getAll();
  Future<List<AppointmentModel>> getByDoctor(String doctorId);
  Future<List<AppointmentModel>> getByPatient(String patientId);
}

class AppointmentRemoteDataSourceImpl implements AppointmentRemoteDataSource {
  final FirebaseRemoteDS<AppointmentModel> _remote;

  AppointmentRemoteDataSourceImpl()
    : _remote = FirebaseRemoteDS<AppointmentModel>(
        collectionName: 'appointments',
        fromFirestore: (doc) => AppointmentModel.fromFirestore(doc),
        toFirestore: (model) => model.toJson(),
      );

  @override
  Future<void> add(AppointmentModel appointment) async {
    await _remote.add(appointment);
  }

  @override
  Future<void> update(AppointmentModel appointment) async {
    await _remote.update(appointment.documentId, appointment);
  }

  @override
  Future<void> delete(String id) async => _remote.delete(id);

  @override
  Future<AppointmentModel?> getById(String id) async => _remote.getById(id);

  @override
  Future<List<AppointmentModel>> getAll() async => _remote.getAll();

  @override
  Future<List<AppointmentModel>> getByDoctor(String doctorId) async =>
      _remote.searchByField('doctorId', doctorId);

  @override
  Future<List<AppointmentModel>> getByPatient(String patientId) async =>
      _remote.searchByField('patientId', patientId);
}
