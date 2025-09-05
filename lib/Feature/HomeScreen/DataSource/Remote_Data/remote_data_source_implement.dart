import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/Core/API/api_constant.dart';
import 'package:movie/Core/API/end_points.dart';
import 'package:movie/Feature/HomeScreen/DataSource/Remote_Data/remote_data_source.dart';
import '../Model/movie_models.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<MovieResponse?> getAvailableNowMovies(
    String? dateUploaded,
    String? minimumRating,
    String? genre,
  ) async {
    Uri url = Uri.https(ApiConstant.movieBaseUrl, EndPoints.listMovies, {
      if (dateUploaded != null) 'sort_by': 'date_added',
      if (minimumRating != null) 'minimum_rating': minimumRating,
      if (genre != null) 'genre': genre,
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var movieResponse = MovieResponse.fromJson(json);
        print("🌐 [بعيد] تم جلب ${movieResponse.data?.movies?.length ?? 0} فيلم من getAvailableNowMovies");
        return movieResponse;
      } else {
        print("❌ خطأ HTTP في getAvailableNowMovies: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ خطأ في getAvailableNowMovies: $e");
      return null;
    }
  }

  @override
  Future<List<String>> getMovieGenres() async {
    Uri url = Uri.https(ApiConstant.movieBaseUrl, EndPoints.listMovies, {
      'limit': '100',
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var movieResponse = MovieResponse.fromJson(json);
        Set<String> genres = {};
        if (movieResponse.data?.movies != null) {
          for (var movie in movieResponse.data!.movies!) {
            if (movie.genres != null) {
              genres.addAll(movie.genres!.map((g) => g.trim().toLowerCase()));
            }
          }
        }
        final genreList = genres.toList()..sort();
        print("🌐 [بعيد] تم جلب ${genreList.length} نوع من getMovieGenres");
        return genreList;
      } else {
        print("❌ خطأ HTTP في getMovieGenres: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ خطأ في getMovieGenres: $e");
      return [];
    }
  }

  @override
  Future<List<Movie>> getMoviesByGenre(String genre) async {
    Uri url = Uri.https(ApiConstant.movieBaseUrl, EndPoints.listMovies, {
      'genre': genre,
    });
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var movieResponse = MovieResponse.fromJson(json);
        final movies = movieResponse.data?.movies ?? [];
        print("🌐 [بعيد] تم جلب ${movies.length} فيلم للنوع '$genre' من getMoviesByGenre");
        return movies;
      } else {
        print("❌ خطأ HTTP في getMoviesByGenre: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ خطأ في getMoviesByGenre: $e");
      return [];
    }
  }
  
}