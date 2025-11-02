class Patient {
  final String documentId; // 🔑 ID của document trong Firestore
  final String name; // 👤 Họ tên bệnh nhân
  final DateTime birthdate; // 🎂 Ngày sinh
  final String gender; // 🚻 Giới tính ("Nam" hoặc "Nữ")
  final String phone; // 📞 Số điện thoại (tùy chọn)
  final String address; // 🏠 Địa chỉ
  final String symptom; // 🤒 Triệu chứng (ho, sốt,...)
  final String imgUrl; // 🖼️ Ảnh đại diện bệnh nhân
  final DateTime createdAt; // ⏰ Thời điểm thêm bệnh nhân
  final DateTime? updatedAt; // 🔄 Thời điểm chỉnh sửa (tùy chọn)

  const Patient({
    required this.documentId,
    required this.name,
    required this.birthdate,
    required this.gender,
    required this.phone,
    required this.address,
    required this.symptom,
    required this.imgUrl,
    required this.createdAt,
    this.updatedAt,
  });

  /// 🧱 Copy để cập nhật dữ liệu dễ dàng (update)
  Patient copyWith({
    String? documentId,
    String? name,
    DateTime? birthdate,
    String? gender,
    String? phone,
    String? address,
    String? symptom,
    String? imgUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      documentId: documentId ?? this.documentId,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      symptom: symptom ?? this.symptom,
      imgUrl: imgUrl ?? this.imgUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 🧩 Chuyển dữ liệu sang Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': documentId,
      'name': name,
      'birthdate': birthdate.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'address': address,
      'symptom': symptom,
      'ImgUrl': imgUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 🧩 Lấy dữ liệu từ Map Firestore
  factory Patient.fromMap(Map<String, dynamic> map, String documentId) {
    return Patient(
      documentId: documentId,
      name: map['name'] ?? '',
      birthdate: map['birthdate'] is String
          ? DateTime.tryParse(map['birthdate']) ?? DateTime.now()
          : (map['birthdate']?.toDate() ?? DateTime.now()),
      gender: map['gender'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      symptom: map['symptom'] ?? '',
      imgUrl: map['ImgUrl'] ?? '',
      createdAt: map['createdAt'] is String
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : (map['createdAt']?.toDate() ?? DateTime.now()),
      updatedAt: map['updatedAt'] == null
          ? null
          : (map['updatedAt'] is String
                ? DateTime.tryParse(map['updatedAt'])
                : map['updatedAt']?.toDate()),
    );
  }

  /// 🩺 Kiểm tra bệnh nhân mới được thêm gần đây (dưới 7 ngày)
  bool get isRecent => DateTime.now().difference(createdAt).inDays <= 7;
}
