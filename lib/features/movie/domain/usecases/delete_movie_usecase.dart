import 'package:datlichhen/features/movie/domain/repositories/movie_repository.dart';

/// ❌ UseCase: Xóa một bộ phim khỏi Firestore
class DeleteMovie {
  final MovieRepository repository;

  DeleteMovie(this.repository);

  Future<void> call(String id) async {
    await repository.deleteMovie(id);
  }
}
