import 'package:datlichhen/features/movie/data/datasources/doctor_remote_datasource.dart';
import 'package:datlichhen/features/movie/data/models/doctor_model.dart';
import 'package:datlichhen/features/movie/domain/entities/doctor_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl extends DoctorRepository {
  final DoctorRemoteDataSource remoteDataSource;

  DoctorRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createDoctor(Doctor doctor) async {
    final doctorModel = DoctorModel.fromEntity(doctor);
    await remoteDataSource.add(doctorModel);
  }

  @override
  Future<void> deleteDoctor(String id) async {
    await remoteDataSource.delete(id);
  }

  @override
  Future<Doctor> getDoctor(String id) async {
    final doctorModel = await remoteDataSource.getDoctor(id);
    if (doctorModel == null) {
      throw Exception('Doctor not found');
    }
    return doctorModel;
  }

  @override
  Future<List<Doctor>> getDoctors() async {
    final doctorModels = await remoteDataSource.getAll();
    return doctorModels;
  }

  @override
  Future<void> updateDoctor(Doctor doctor) async {
    await remoteDataSource.update(DoctorModel.fromEntity(doctor));
  }

  @override
  Future<List<Doctor>> getDoctorsByField(String field, String query) async {
    final doctors = await remoteDataSource.getDoctorsByField(field, query);
    return doctors;
  }
}
