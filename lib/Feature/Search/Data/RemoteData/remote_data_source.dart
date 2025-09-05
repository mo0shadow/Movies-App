import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';

abstract class IDataSource {
  Future<List<Movie>> fetchMovies({String query});
}