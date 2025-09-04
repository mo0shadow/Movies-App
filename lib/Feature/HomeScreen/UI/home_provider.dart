import 'package:flutter/material.dart';
import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';
import 'package:movie/Feature/HomeScreen/Repository/movie_repository.dart';

enum ViewState { idle, loading, error }

class MovieProvider extends ChangeNotifier {
  ViewState availableNowState = ViewState.idle;
  ViewState allMoviesState = ViewState.idle;

  List<Movie> availableNowMovies = [];
  List<String> movieGenres = [];
  Map<String, List<Movie>> moviesByGenre = {};
  String errorMessage = '';

  final MovieRepository movieRepository;

  MovieProvider({required this.movieRepository});

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchAvailableNowMovies(),
      fetchMoviesByGenre(),
    ]);
  }

  Future<void> fetchAvailableNowMovies() async {
    availableNowState = ViewState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      final movies = await movieRepository.getAvailableNowMovies();
      availableNowMovies = movies;
      availableNowState = ViewState.idle;
    } catch (e) {
      errorMessage = e.toString();
      availableNowState = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> fetchMoviesByGenre() async {
    allMoviesState = ViewState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      final genres = await movieRepository.getMovieGenres();
      movieGenres = genres;
      moviesByGenre = {};

      for (var genre in genres) {
        final movies = await movieRepository.getMoviesByGenre(genre);
        moviesByGenre[genre] = movies;
      }

      allMoviesState = ViewState.idle;
    } catch (e) {
      errorMessage = e.toString();
      allMoviesState = ViewState.error;
    }

    notifyListeners();
  }
}
