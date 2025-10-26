import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/doctor_entity.dart';

class DoctorModel extends Doctor {
  const DoctorModel({
    required super.documentId,
    required super.userId,
    required super.hoTen,
    required super.sdt,
    required super.chuyenKhoa,
    required super.year,
    required super.imgUrl,
    required super.createdAt,
  });

  /// 🔹 Lấy dữ liệu từ Firestore → DoctorModel
  factory DoctorModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoctorModel(
      documentId: doc.id,
      userId: data['userId'] ?? '',
      hoTen: data['HoTen'] ?? '',
      sdt: data['SDT'] ?? '',
      chuyenKhoa: data['ChuyenKhoa'] ?? '',
      year: (data['year'] ?? 0).toInt(),
      imgUrl: data['ImgUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// 🔹 Chuyển DoctorModel → Map để lưu lên Firestore
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'HoTen': hoTen,
    'SDT': sdt,
    'ChuyenKhoa': chuyenKhoa,
    'year': year,
    'ImgUrl': imgUrl,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  /// 🔹 Tạo DoctorModel từ DoctorEntity (domain)
  factory DoctorModel.fromEntity(Doctor entity) => DoctorModel(
    documentId: entity.documentId,
    userId: entity.userId,
    hoTen: entity.hoTen,
    sdt: entity.sdt,
    chuyenKhoa: entity.chuyenKhoa,
    year: entity.year,
    imgUrl: entity.imgUrl,
    createdAt: entity.createdAt,
  );

  /// 🔹 Chuyển DoctorModel → DoctorEntity (nếu cần trong domain layer)
  Doctor toEntity() => Doctor(
    documentId: documentId,
    userId: userId,
    hoTen: hoTen,
    sdt: sdt,
    chuyenKhoa: chuyenKhoa,
    year: year,
    imgUrl: imgUrl,
    createdAt: createdAt,
  );
}
