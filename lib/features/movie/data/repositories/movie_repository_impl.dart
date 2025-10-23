import 'package:datlichhen/features/movie/data/datasources/movie_remote_datasource.dart';
import 'package:datlichhen/features/movie/data/models/movie_model.dart';
import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createMovie(Movie movie) async {
    final movieModel = MovieModel.fromEntity(movie);
    await remoteDataSource.add(movieModel);
  }

  @override
  Future<void> deleteMovie(String id) async {
    await remoteDataSource.delete(id);
  }

  @override
  Future<Movie> getMovie(String id) async {
    final movieModel = await remoteDataSource.getMovie(id);
    if (movieModel == null) {
      throw Exception('Movie not found');
    }
    return movieModel;
  }

  @override
  Future<List<Movie>> getMovies() async {
    final movieModels = await remoteDataSource.getAll();
    return movieModels;
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    await remoteDataSource.update(MovieModel.fromEntity(movie));
  }

  @override
  Future<List<Movie>> getMoviesByGenre(String genre, String query) async {
    final movies = await remoteDataSource.getMoviesByGenre(genre, query);
    return movies;
  }
}
