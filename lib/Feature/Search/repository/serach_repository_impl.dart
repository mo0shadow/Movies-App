import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';
import 'package:movie/Feature/Search/Data/RemoteData/remote_data_source.dart';
import 'package:movie/Feature/Search/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final IDataSource _dataSource;

  SearchRepositoryImpl(this._dataSource);

  @override
  Future<List<Movie>> searchMovies({required String query}) async {
    return _dataSource.fetchMovies(query: query);
  }
}