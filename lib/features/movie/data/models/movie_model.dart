import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/movie_entity.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.documentId,
    required super.userId,
    required super.title,
    required super.director,
    required super.genre,
    required super.year,
    required super.posterUrl,
    required super.trailerUrl,
    required super.createdAt,
  });

  /// 🔹 Lấy dữ liệu từ Firestore → MovieModel
  factory MovieModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MovieModel(
      documentId: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      director: data['director'] ?? '',
      genre: data['genre'] ?? '',
      year: (data['year'] ?? 0).toInt(),
      posterUrl: data['posterUrl'] ?? '',
      trailerUrl: data['trailerUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// 🔹 Chuyển MovieModel → Map để lưu lên Firestore
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'title': title,
    'director': director,
    'genre': genre,
    'year': year,
    'posterUrl': posterUrl,
    'trailerUrl': trailerUrl,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  /// 🔹 Tạo MovieModel từ MovieEntity (domain)
  factory MovieModel.fromEntity(Movie entity) => MovieModel(
    documentId: entity.documentId,
    userId: entity.userId,
    title: entity.title,
    director: entity.director,
    genre: entity.genre,
    year: entity.year,
    posterUrl: entity.posterUrl,
    trailerUrl: entity.trailerUrl,
    createdAt: entity.createdAt,
  );

  /// 🔹 Chuyển MovieModel → MovieEntity (nếu cần trong domain layer)
  Movie toEntity() => Movie(
    documentId: documentId,
    userId: userId,
    title: title,
    director: director,
    genre: genre,
    year: year,
    posterUrl: posterUrl,
    trailerUrl: trailerUrl,
    createdAt: createdAt,
  );
}
