import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie/Core/API/api_constant.dart';
import 'package:movie/Core/API/end_points.dart';
import 'package:movie/Feature/HomeScreen/DataSource/Model/movie_models.dart';
import 'package:movie/Feature/Search/Data/RemoteData/remote_data_source.dart';

class YtsDataSource implements IDataSource {
 
  @override
  Future<List<Movie>> fetchMovies({String query = ''}) async {
    try {
      Uri url = Uri.https(ApiConstant.movieBaseUrl, EndPoints.listMovies,{"query_term":query});
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> moviesJson = data['data']['movies'] ?? [];
        print('API Raw Response: ${data.toString()}'); // Add logging
        return moviesJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}