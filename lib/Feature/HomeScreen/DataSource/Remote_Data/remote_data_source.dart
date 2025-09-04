import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';
abstract class RemoteDataSource {
  Future<MovieResponse?> getAvailableNowMovies(
      String? dateUploaded, String? minimumRating, String? genre);
  Future<List<String>> getMovieGenres();
  Future<List<Movie>> getMoviesByGenre(String genre);
  // Future<Movie?> getMovieDetails(int movieId);
}