class Appointment {
  final String documentId; // 🔑 ID trong Firestore
  final String patientId; // 👤 ID bệnh nhân
  final String doctorId; // 🩺 ID bác sĩ
  final DateTime appointmentTime; // 📅 Thời gian hẹn
  final String symptom; // 🤒 Triệu chứng
  final String status; // ⏱️ pending | confirmed | cancelled
  final DateTime createdAt; // 🕒 Ngày tạo
  final DateTime? updatedAt; // 🔄 Ngày cập nhật

  const Appointment({
    required this.documentId,
    required this.patientId,
    required this.doctorId,
    required this.appointmentTime,
    required this.symptom,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  Appointment copyWith({
    String? documentId,
    String? patientId,
    String? doctorId,
    DateTime? appointmentTime,
    String? symptom,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      documentId: documentId ?? this.documentId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      symptom: symptom ?? this.symptom,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
