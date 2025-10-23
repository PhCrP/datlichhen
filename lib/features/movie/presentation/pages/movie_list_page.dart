import 'package:flutter/material.dart';
import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/usecases/create_movie_usecase.dart';
import 'package:datlichhen/features/movie/domain/usecases/delete_movie_usecase.dart';
import 'package:datlichhen/features/movie/domain/usecases/get_all_movie.dart';
import 'package:datlichhen/features/movie/domain/usecases/search_movie_usecase.dart';
import 'package:datlichhen/features/movie/domain/usecases/update_movie_usecase.dart';
import 'package:datlichhen/features/movie/data/datasources/movie_remote_datasource.dart';
import 'package:datlichhen/features/movie/data/repositories/movie_repository_impl.dart';
import 'movie_form_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late final _remote = MovieRemoteDataSourceImpl();
  late final _repo = MovieRepositoryImpl(_remote);

  late final _getAllMovies = GetAllMovies(_repo);
  late final _addMovie = AddMovie(_repo);
  late final _updateMovie = UpdateMovie(_repo);
  late final _deleteMovie = DeleteMovie(_repo);
  late final _searchMovies = GetMoviesByGenre(_repo);

  List<Movie> _movies = [];
  String _searchQuery = "";
  String _selectedGenre = "Tất cả";

  final _searchController = TextEditingController();
  final _genres = ["Tất cả", "Action", "Comedy", "Drama", "Horror", "Sci-Fi"];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final movies = await _getAllMovies();
    movies.sort((a, b) => b.year.compareTo(a.year));
    setState(() => _movies = movies);
  }

  Future<void> _search() async {
    if (_searchQuery.isEmpty && _selectedGenre == "Tất cả") {
      _loadMovies();
    } else {
      final results = await _searchMovies(_selectedGenre, _searchQuery);
      setState(() => _movies = results);
    }
  }

  Future<void> _delete(String id) async {
    await _deleteMovie(id);
    await _loadMovies();
  }

  Future<void> _openForm([Movie? movie]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieFormPage(
          movie: movie,
          addUseCase: _addMovie,
          updateUseCase: _updateMovie,
        ),
      ),
    );
    if (result == true) _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          '🎬 Quản lý phim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),

      // 🔍 THANH TÌM KIẾM + FILTER
      body: Column(
        children: [
          Container(
            color: Colors.deepPurple.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "🔎 Tìm kiếm phim...",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                          _search();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGenre,
                        items: _genres
                            .map((g) => DropdownMenuItem(
                                  value: g,
                                  child: Text(g),
                                ))
                            .toList(),
                        onChanged: (v) {
                          setState(() => _selectedGenre = v!);
                          _search();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🎞️ DANH SÁCH DẠNG LƯỚI
          Expanded(
            child: _movies.isEmpty
                ? const Center(
                    child: Text(
                      'Không có phim nào!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadMovies,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2,
                      ),
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return GestureDetector(
                          onTap: () => _showMovieDetail(movie),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Poster
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    movie.posterUrl,
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(color: Colors.grey.shade300),
                                  ),
                                ),
                              ),

                              // Overlay info
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(16)),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),

                              // Thông tin phim
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      movie.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black,
                                              blurRadius: 4)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${movie.genre} • ${movie.year}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),

                              // Nút sửa / xóa
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Row(
                                  children: [
                                    _circleBtn(
                                      icon: Icons.edit,
                                      color: Colors.orangeAccent,
                                      onTap: () => _openForm(movie),
                                    ),
                                    const SizedBox(width: 6),
                                    _circleBtn(
                                      icon: Icons.delete,
                                      color: Colors.redAccent,
                                      onTap: () => _delete(movie.documentId),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      // ➕ FAB Thêm phim
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  // Widget nút tròn edit/xóa
  Widget _circleBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }

  // Xem chi tiết phim
  void _showMovieDetail(Movie movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(movie.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Đạo diễn: ${movie.director}"),
            Text("Thể loại: ${movie.genre}"),
            Text("Năm: ${movie.year}"),
            const SizedBox(height: 10),
            if (movie.trailerUrl.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  // mở link trailer
                },
                icon: const Icon(Icons.play_circle_fill),
                label: const Text("Xem Trailer"),
              ),
          ],
        ),
      ),
    );
  }
}
