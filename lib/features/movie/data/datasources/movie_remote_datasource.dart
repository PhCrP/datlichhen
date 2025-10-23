import 'package:datlichhen/core/data/firebase_remote_datasource.dart';
import 'package:datlichhen/features/movie/data/models/movie_model.dart';

/// 🔹 Interface định nghĩa các hành động với Firestore cho Movie
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getAll();
  Future<MovieModel?> getMovie(String id);
  Future<void> add(MovieModel movie);
  Future<void> update(MovieModel movie);
  Future<void> delete(String id);
  Future<List<MovieModel>> getMoviesByGenre(String genre, String query);
}

/// 🔹 Triển khai cụ thể bằng Firestore thông qua FirebaseRemoteDS
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final FirebaseRemoteDS<MovieModel> _remoteSource;

  MovieRemoteDataSourceImpl()
    : _remoteSource = FirebaseRemoteDS<MovieModel>(
        collectionName: 'movies',
        fromFirestore: (doc) => MovieModel.fromFirestore(doc),
        toFirestore: (model) => model.toJson(),
      );

  @override
  Future<List<MovieModel>> getAll() async {
    final movies = await _remoteSource.getAll();
    return movies;
  }

  @override
  Future<MovieModel?> getMovie(String id) async {
    final movie = await _remoteSource.getById(id);
    return movie;
  }

  @override
  Future<void> add(MovieModel movie) async {
    await _remoteSource.add(movie);
  }

  @override
  Future<void> update(MovieModel movie) async {
    await _remoteSource.update(movie.documentId, movie);
  }

  @override
  Future<void> delete(String id) async {
    await _remoteSource.delete(id);
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre(String genre, String query) async {
    final movies = await _remoteSource.searchByField(genre, query);
    return movies;
  }
}
