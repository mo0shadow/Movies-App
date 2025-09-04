import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';

abstract class SearchRepository {
  Future<List<Movie>> searchMovies({required String query});
}