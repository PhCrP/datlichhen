import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/movie_repository.dart';

/// 🎬 UseCase: Lấy danh sách tất cả phim từ Firestore
class GetAllMovies {
  final MovieRepository repository;

  GetAllMovies(this.repository);

  Future<List<Movie>> call() => repository.getMovies();
}
