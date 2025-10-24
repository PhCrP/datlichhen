class Doctor {
  final String documentId; // 🔑 ID của document trong Firestore
  final String userId; // 🔹 ID người dùng (đăng nhập qua Firebase Auth)
  final String hoTen; // 👨‍⚕️ Họ tên (hiển thị với tiền tố 'Bn.')
  final String sdt; // 📞 Số điện thoại
  final String chuyenKhoa; // 🩺 Chuyên khoa
  final int year; // 📅 Năm thêm (dùng để sắp xếp)
  final String imgUrl; // 🖼️ Link ảnh bác sĩ
  final DateTime createdAt; // ⏰ Thời điểm thêm bác sĩ

  const Doctor({
    required this.documentId,
    required this.userId,
    required this.hoTen,
    required this.sdt,
    required this.chuyenKhoa,
    required this.year,
    required this.imgUrl,
    required this.createdAt,
  });

  /// 🧱 Copy để cập nhật dữ liệu dễ dàng (update)
  Doctor copyWith({
    String? documentId,
    String? userId,
    String? hoTen,
    String? sdt,
    String? chuyenKhoa,
    int? year,
    String? imgUrl,
    DateTime? createdAt,
  }) {
    return Doctor(
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      hoTen: hoTen ?? this.hoTen,
      sdt: sdt ?? this.sdt,
      chuyenKhoa: chuyenKhoa ?? this.chuyenKhoa,
      year: year ?? this.year,
      imgUrl: imgUrl ?? this.imgUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 🧩 Chuyển dữ liệu sang Map để lưu Firestore (nếu cần)
  Map<String, dynamic> toMap() {
    return {
      'id': documentId,
      'userId': userId,
      'HoTen': hoTen,
      'SDT': sdt,
      'ChuyenKhoa': chuyenKhoa,
      'year': year,
      'ImgUrl': imgUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 🧩 Lấy dữ liệu từ Map (nếu cần)
  factory Doctor.fromMap(Map<String, dynamic> map, String documentId) {
    return Doctor(
      documentId: documentId,
      userId: map['userId'] ?? '',
      hoTen: map['HoTen'] ?? '',
      sdt: map['SDT'] ?? '',
      chuyenKhoa: map['ChuyenKhoa'] ?? '',
      year: (map['year'] ?? 0).toInt(),
      imgUrl: map['ImgUrl'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🧮 Kiểm tra bác sĩ mới (nếu muốn)
  bool get isRecent => DateTime.now().year - year <= 2;
}
