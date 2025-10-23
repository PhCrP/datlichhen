class Movie {
  final String documentId; // 🔑 ID của document trong Firestore
  final String userId; // 🔹 ID người dùng (đăng nhập qua Firebase Auth)
  final String title; // 🎬 Tên phim
  final String director; // 🎥 Đạo diễn
  final String genre; // 🔹 Thể loại: Action, Comedy, Drama, Horror, Sci-Fi
  final int year; // 📅 Năm phát hành
  final String posterUrl; // 🖼️ Link ảnh poster
  final String trailerUrl; // ▶️ Link trailer video
  final DateTime createdAt; // ⏰ Thời điểm thêm phim

  const Movie({
    required this.documentId,
    required this.userId,
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    required this.posterUrl,
    required this.trailerUrl,
    required this.createdAt,
  });

  /// 🧱 Copy để cập nhật dữ liệu dễ dàng (update)
  Movie copyWith({
    String? documentId,
    String? userId,
    String? title,
    String? director,
    String? genre,
    int? year,
    String? posterUrl,
    String? trailerUrl,
    DateTime? createdAt,
  }) {
    return Movie(
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      posterUrl: posterUrl ?? this.posterUrl,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 🧩 Chuyển dữ liệu sang Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': documentId,
      'userId': userId,
      'title': title,
      'director': director,
      'genre': genre,
      'year': year,
      'posterUrl': posterUrl,
      'trailerUrl': trailerUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 🧩 Lấy dữ liệu từ Firestore (DocumentSnapshot)
  factory Movie.fromMap(Map<String, dynamic> map, String documentId) {
    return Movie(
      documentId: documentId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      director: map['director'] ?? '',
      genre: map['genre'] ?? '',
      year: (map['year'] ?? 0).toInt(),
      posterUrl: map['posterUrl'] ?? '',
      trailerUrl: map['trailerUrl'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// 🧮 Kiểm tra xem phim có phải “mới nhất” (ra mắt trong 2 năm gần đây)
  bool get isNewRelease => DateTime.now().year - year <= 2;
}
