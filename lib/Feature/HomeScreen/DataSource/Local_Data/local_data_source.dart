import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';

abstract class LocalDataSource {
  Future<List<Movie>> getAvailableNowMovies();
  Future<void> saveAvailableNowMovies(List<Movie> movies);

  Future<List<Movie>> getMoviesByGenre(String genre);
  Future<void> saveMoviesByGenre(String genre, List<Movie> movies);

  // Future<Movie?> getMovieDetails(int movieId);
  // Future<void> saveMovieDetails(int movieId, Movie movie);

 
  Future<List<String>> getMovieGenres();
  Future<void> saveMovieGenres(List<String> genres);
}
