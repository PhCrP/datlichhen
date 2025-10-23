import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/movie_repository.dart';

/// 🔍 UseCase: Lọc & tìm kiếm phim theo thể loại và từ khóa tiêu đề
class GetMoviesByGenre {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> call(String genre, String query) =>
      repository.getMoviesByGenre(genre, query);
}
