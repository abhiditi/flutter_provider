import 'package:dio/dio.dart';
import 'package:flutterprovider/model/movie_detail_response.dart';

class GenreBloc {
  final String apiKey = "a413dc1e70d4133769723e788efbbd83";
  static String mainUrl = "https://api.themoviedb.org/3";
  final Dio _dio = Dio();
  var movieUrl = '$mainUrl/movie';
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    var params = {"api_key": apiKey, "language": "en-US"};
    try {
      Response response =
          await _dio.get(movieUrl + "/$id", queryParameters: params);
      return MovieDetailResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return MovieDetailResponse.withError("$error");
    }
  }
}
