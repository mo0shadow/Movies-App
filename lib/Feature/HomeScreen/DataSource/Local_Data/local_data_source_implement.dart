import 'package:hive/hive.dart';
import '../Model/movie_models.dart';
import 'local_data_source.dart';

class LocalDataSourceImpl implements LocalDataSource {
  static const String availableNowBox = 'available_now_movies';
  static const String genresBox = 'movie_genres';

  String normalizeGenre(String genre) {
    return genre.trim().toLowerCase();
  }

  @override
  Future<List<Movie>> getAvailableNowMovies() async {
    try {
      final box = await Hive.openBox<Movie>(availableNowBox);
      final movies = box.values.toList();
      print("📦 [محلي] تم تحميل ${movies.length} فيلم من $availableNowBox");
      return movies;
    } catch (e) {
      print("❌ خطأ في الوصول لـ $availableNowBox: $e");
      return [];
    }
  }

  @override
  Future<void> saveAvailableNowMovies(List<Movie> movies) async {
    try {
      final box = await Hive.openBox<Movie>(availableNowBox);
      await box.clear();
      await box.addAll(movies);
      print("💾 [محلي] تم حفظ ${movies.length} فيلم في $availableNowBox");
    } catch (e) {
      print("❌ خطأ في الحفظ في $availableNowBox: $e");
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(String genre) async {
    final boxName = 'movies_${normalizeGenre(genre)}';
    try {
      final box = await Hive.openBox<Movie>(boxName);
      final movies = box.values.toList();
      print("📦 [محلي] تم تحميل ${movies.length} فيلم للنوع '$genre' من $boxName");
      return movies;
    } catch (e) {
      print("❌ خطأ في الوصول لـ $boxName: $e");
      return [];
    }
  }

  @override
  Future<void> saveMoviesByGenre(String genre, List<Movie> movies) async {
    final boxName = 'movies_${normalizeGenre(genre)}';
    try {
      final box = await Hive.openBox<Movie>(boxName);
      await box.clear();
      await box.addAll(movies);
      print("💾 [محلي] تم حفظ ${movies.length} فيلم للنوع '$genre' في $boxName");
    } catch (e) {
      print("❌ خطأ في الحفظ في $boxName: $e");
    }
  }

  @override
  Future<void> saveMovieGenres(List<String> genres) async {
    try {
      final box = await Hive.openBox<String>(genresBox);
      await box.clear();
      final normalizedGenres = genres.map((g) => g.trim().toLowerCase()).toList();
      await box.addAll(normalizedGenres);
      print("💾 [محلي] تم حفظ ${normalizedGenres.length} نوع في $genresBox");
    } catch (e) {
      print("❌ خطأ في الحفظ في $genresBox: $e");
    }
  }

  @override
  Future<List<String>> getMovieGenres() async {
    try {
      final box = await Hive.openBox<String>(genresBox);
      final genres = box.values.toList();
      print("📦 [محلي] تم تحميل ${genres.length} نوع من $genresBox");
      return genres;
    } catch (e) {
      print("❌ خطأ في الوصول لـ $genresBox: $e");
      return [];
    }
  }
}