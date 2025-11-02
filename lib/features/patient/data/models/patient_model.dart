import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datlichhen/features/auth/presentation/pages/sign_up_page.dart';
import '../../domain/entities/patient_entity.dart';

/// 🩺 Model cho tầng Data — biểu diễn dữ liệu bệnh nhân trong Firestore
class PatientModel extends Patient {
  const PatientModel({
    required super.documentId,
    required super.name,
    required super.birthdate,
    required super.gender,
    required super.phone,
    required super.address,
    required super.symptom,
    required super.imgUrl,
    required super.createdAt,
    super.updatedAt,
  });

  /// 🔹 Lấy dữ liệu từ Firestore → PatientModel
  factory PatientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PatientModel(
      documentId: doc.id,
      name: data['name'] ?? '',
      birthdate: _parseDate(data['birthdate']),
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      symptom: data['symptom'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      createdAt: _parseDate(data['createdAt']),
      updatedAt: data['updatedAt'] == null
          ? null
          : _parseDate(data['updatedAt']),
    );
  }

  /// 🔹 Chuyển PatientModel → Map để lưu lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthdate': Timestamp.fromDate(birthdate),
      'gender': gender,
      'phone': phone,
      'address': address,
      'symptom': symptom,
      'imgUrl': imgUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// 🔹 Tạo PatientModel từ PatientEntity (domain)
  factory PatientModel.fromEntity(Patient entity) {
    return PatientModel(
      documentId: entity.documentId,
      name: entity.name,
      birthdate: entity.birthdate,
      gender: entity.gender,
      phone: entity.phone,
      address: entity.address,
      symptom: entity.symptom,
      imgUrl: entity.imgUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// 🔹 Chuyển PatientModel → PatientEntity (domain)
  Patient toEntity() {
    return Patient(
      documentId: documentId,
      name: name,
      birthdate: birthdate,
      gender: gender,
      phone: phone,
      address: address,
      symptom: symptom,
      imgUrl: imgUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// 🧩 Hàm tiện ích parse Timestamp hoặc String sang DateTime
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
