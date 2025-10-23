import 'package:flutter/material.dart';
import 'package:datlichhen/features/movie/domain/entities/movie_entity.dart';
import 'package:datlichhen/features/movie/domain/usecases/create_movie_usecase.dart';
import 'package:datlichhen/features/movie/domain/usecases/update_movie_usecase.dart';

class MovieFormPage extends StatefulWidget {
  final Movie? movie;
  final AddMovie addUseCase;
  final UpdateMovie updateUseCase;

  const MovieFormPage({
    super.key,
    this.movie,
    required this.addUseCase,
    required this.updateUseCase,
  });

  @override
  State<MovieFormPage> createState() => _MovieFormPageState();
}

class _MovieFormPageState extends State<MovieFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _director;
  late String _genre;
  late int _year;
  late String _posterUrl;
  late String _trailerUrl;

  final _genres = ['Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi'];

  @override
  void initState() {
    super.initState();
    final m = widget.movie;
    _title = m?.title ?? '';
    _director = m?.director ?? '';
    _genre = m?.genre ?? 'Action';
    _year = m?.year ?? DateTime.now().year;
    _posterUrl = m?.posterUrl ?? '';
    _trailerUrl = m?.trailerUrl ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final movie = Movie(
      documentId: widget.movie?.documentId ?? '',
      userId: widget.movie?.userId ?? 'unknown',
      title: _title,
      director: _director,
      genre: _genre,
      year: _year,
      posterUrl: _posterUrl,
      trailerUrl: _trailerUrl,
      createdAt: widget.movie?.createdAt ?? DateTime.now(),
    );

    if (widget.movie == null) {
      await widget.addUseCase(movie);
    } else {
      await widget.updateUseCase(movie);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.movie != null;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          isEdit ? '🎬 Cập nhật phim' : '🎥 Thêm phim mới',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: color.primaryContainer,
        foregroundColor: color.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 🖼 Poster preview
                  GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                        image: _posterUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(_posterUrl),
                                fit: BoxFit.cover,
                                onError: (_, __) {},
                              )
                            : null,
                      ),
                      child: _posterUrl.isEmpty
                          ? const Center(
                              child: Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.grey),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🎞 Title
                  TextFormField(
                    initialValue: _title,
                    decoration: _input('Tên phim', Icons.movie_creation_outlined),
                    validator: (v) =>
                        v!.isEmpty ? 'Vui lòng nhập tên phim' : null,
                    onSaved: (v) => _title = v!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // 👨‍💼 Director
                  TextFormField(
                    initialValue: _director,
                    decoration:
                        _input('Đạo diễn', Icons.person_outline_rounded),
                    validator: (v) =>
                        v!.isEmpty ? 'Vui lòng nhập tên đạo diễn' : null,
                    onSaved: (v) => _director = v!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // 🎭 Genre
                  DropdownButtonFormField<String>(
                    value: _genre,
                    decoration: _input('Thể loại', Icons.category_outlined),
                    items: _genres
                        .map((g) =>
                            DropdownMenuItem(value: g, child: Text('🎬 $g')))
                        .toList(),
                    onChanged: (v) => setState(() => _genre = v!),
                  ),
                  const SizedBox(height: 16),

                  // 📅 Year
                  TextFormField(
                    initialValue: _year.toString(),
                    decoration:
                        _input('Năm phát hành', Icons.calendar_month_outlined),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final y = int.tryParse(v ?? '');
                      if (y == null ||
                          y < 1900 ||
                          y > DateTime.now().year + 1) {
                        return 'Năm phát hành không hợp lệ';
                      }
                      return null;
                    },
                    onSaved: (v) => _year = int.parse(v!.trim()),
                  ),
                  const SizedBox(height: 16),

                  // 🌆 Poster URL
                  TextFormField(
                    initialValue: _posterUrl,
                    decoration: _input('URL Poster (ảnh)', Icons.image_outlined),
                    onChanged: (v) => setState(() => _posterUrl = v.trim()),
                    onSaved: (v) => _posterUrl = v!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // ▶ Trailer
                  TextFormField(
                    initialValue: _trailerUrl,
                    decoration: _input('URL Trailer (YouTube)',
                        Icons.play_circle_outline_rounded),
                    onSaved: (v) => _trailerUrl = v!.trim(),
                  ),
                  const SizedBox(height: 15),

                  // ✅ Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
                      label: Text(
                        isEdit ? 'Cập nhật phim' : 'Thêm phim',
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🎨 Input Decoration Helper
  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
