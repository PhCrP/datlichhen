import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';

/// 🔹 Repository trừu tượng cho tính năng quản lý phim.
/// Định nghĩa các hành động CRUD + lọc, tìm kiếm.
abstract class MovieRepository {
  /// 📥 Lấy danh sách tất cả phim (FireStore)
  Future<List<Movie>> getMovies();

  /// 📄 Lấy thông tin chi tiết của một phim theo ID
  Future<Movie> getMovie(String id);

  /// ➕ Thêm phim mới
  Future<void> createMovie(Movie movie);

  /// ✏️ Cập nhật thông tin phim
  Future<void> updateMovie(Movie movie);

  /// ❌ Xóa phim theo ID
  Future<void> deleteMovie(String id);

  /// 🔍 Lọc và tìm kiếm phim theo thể loại và từ khóa (title)
  Future<List<Movie>> getMoviesByGenre(String genre, String query);
}
