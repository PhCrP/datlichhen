import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/movie_repository.dart';

/// 🟢 UseCase: Thêm một bộ phim mới vào Firestore
class AddMovie {
  final MovieRepository repository;

  AddMovie(this.repository);

  Future<void> call(Movie movie) {
    return repository.createMovie(movie);
  }
}
