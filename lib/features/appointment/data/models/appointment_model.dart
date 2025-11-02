import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datlichhen/features/appointment/domain/entities/appointment_entity.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.documentId,
    required super.patientId,
    required super.doctorId,
    required super.appointmentTime,
    required super.symptom,
    required super.status,
    required super.createdAt,
    super.updatedAt,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      documentId: doc.id,
      patientId: data['patientId'] ?? '',
      doctorId: data['doctorId'] ?? '',
      appointmentTime: (data['appointmentTime'] as Timestamp).toDate(),
      symptom: data['symptom'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentTime': appointmentTime,
      'symptom': symptom,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      documentId: appointment.documentId,
      patientId: appointment.patientId,
      doctorId: appointment.doctorId,
      appointmentTime: appointment.appointmentTime,
      symptom: appointment.symptom,
      status: appointment.status,
      createdAt: appointment.createdAt,
      updatedAt: appointment.updatedAt,
    );
  }
}
