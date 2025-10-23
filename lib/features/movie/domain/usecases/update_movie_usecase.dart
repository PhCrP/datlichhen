import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/movie_repository.dart';

/// ✏️ UseCase: Cập nhật thông tin phim trong Firestore
class UpdateMovie {
  final MovieRepository repository;

  UpdateMovie(this.repository);

  Future<void> call(Movie movie) async {
    await repository.updateMovie(movie);
  }
}
