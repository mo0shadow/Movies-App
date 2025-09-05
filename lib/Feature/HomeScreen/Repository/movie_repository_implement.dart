import 'package:connectivity_plus/connectivity_plus.dart';

import '../DataSource/Local_Data/local_data_source.dart';
import '../DataSource/Model/movie_models.dart';
import '../DataSource/Remote_Data/remote_data_source.dart';
import 'movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  MovieRepositoryImpl(this.remoteDataSource, this.localDataSource);

  String _normalizeGenre(String genre) => genre.trim().toLowerCase();

  Future<bool> _hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<Movie>> getAvailableNowMovies({
    String? dateUploaded,
    String? minimumRating,
    String? genre,
  }) async {
    if (await _hasConnection()) {
      try {
        final remoteMovies = await remoteDataSource.getAvailableNowMovies(
          dateUploaded,
          minimumRating,
          genre != null ? _normalizeGenre(genre) : null,
        );
        if (remoteMovies?.data?.movies != null) {
          await localDataSource.saveAvailableNowMovies(remoteMovies!.data!.movies!);
          return remoteMovies.data!.movies!;
        }
      } catch (e) {
        print("❌ Remote fetch failed: $e");
      }
    }

    // fallback للـ local
    final localMovies = await localDataSource.getAvailableNowMovies();
    if (localMovies.isEmpty) {
      print("⚠️ No local available now movies");
    }
    return localMovies;
  }

  @override
  Future<List<String>> getMovieGenres() async {
    if (await _hasConnection()) {
      try {
        final remoteGenres = await remoteDataSource.getMovieGenres();
        if (remoteGenres.isNotEmpty) {
          final normalized = remoteGenres.map(_normalizeGenre).toList();
          await localDataSource.saveMovieGenres(normalized);
          return normalized;
        }
      } catch (e) {
        print("❌ Remote genres fetch failed: $e");
      }
    }

    // fallback للـ local
    final localGenres = await localDataSource.getMovieGenres();
    if (localGenres.isEmpty) print("⚠️ No local genres");
    return localGenres;
  }

  @override
  Future<List<Movie>> getMoviesByGenre(String genre) async {
    final normalizedGenre = _normalizeGenre(genre);

    if (await _hasConnection()) {
      try {
        final remoteMovies = await remoteDataSource.getMoviesByGenre(normalizedGenre);
        if (remoteMovies.isNotEmpty) {
          await localDataSource.saveMoviesByGenre(normalizedGenre, remoteMovies);
          return remoteMovies;
        }
      } catch (e) {
        print("❌ Remote movies by genre failed: $e");
      }
    }

    // fallback للـ local
    final localMovies = await localDataSource.getMoviesByGenre(normalizedGenre);
    if (localMovies.isEmpty) print("⚠️ No local movies for '$normalizedGenre'");
    return localMovies;
  }
}
