import 'package:flutter/material.dart';
import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';
import 'package:movie/Feature/Search/repository/search_repository.dart';

enum AppState { initial, loading, loaded, error }

class SearchProvider with ChangeNotifier {
  final SearchRepository repository;
  AppState _state = AppState.initial;
  List<Movie> _movies = [];
  String _errorMessage = '';

  SearchProvider({required this.repository});

  AppState get state => _state;
  List<Movie> get movies => _movies;
  String get errorMessage => _errorMessage;

  Future<void> searchMovies(String query) async {
    _state = AppState.loading;
    _movies = [];
    notifyListeners();

    if (query.isEmpty) {
      _state = AppState.initial;
      notifyListeners();
      return;
    }

    try {
      // Fetch movies from the repository
      final allMovies = await repository.searchMovies(query: query);
      print('API Response: Found ${allMovies.length} movies for query "$query"');

      // Filter movies to include those whose titles contain the query (case-insensitive)
      _movies = allMovies.where((movie) {
        final title = movie.title?.toLowerCase() ?? '';
        final queryLower = query.toLowerCase();
        return title.contains(queryLower); // Changed from startsWith to contains for broader matching
      }).toList();

      print('Filtered Movies: ${_movies.length} movies after filtering');
      if (_movies.isEmpty) {
        print('No movies matched the query "$query" after filtering');
      } else {
        _movies.forEach((movie) => print('Matched Movie: ${movie.title}'));
      }

      _state = AppState.loaded;
    } catch (e) {
      _errorMessage = 'Error: No movies found or a network issue occurred. Details: $e';
      _state = AppState.error;
      print('Search Error: $e');
    }
    notifyListeners();
  }
}